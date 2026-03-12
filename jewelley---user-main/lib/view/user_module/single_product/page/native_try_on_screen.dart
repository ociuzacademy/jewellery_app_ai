import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';

class NativeTryOnScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String category;

  const NativeTryOnScreen({super.key, required this.cameras, required this.category});

  @override
  State<NativeTryOnScreen> createState() => _NativeTryOnScreenState();
}

class _NativeTryOnScreenState extends State<NativeTryOnScreen> {
  late CameraController _controller;
  late FaceMeshDetector _meshDetector;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  List<FaceMesh>? _faceMeshes;
  ui.Image? _necklaceImage;
  ui.Image? _earringImage;
  CameraImage? _latestImage;

  // AR Adjustment Variables
  double _neckYOffset = 180.0;
  double _neckScale = 2.5;

  // Assets
  final List<String> _necklaceAssets = [
    'assets/try_on/neck.png',
    'assets/try_on/daimond.png',
    'assets/try_on/diamond 2.png',
  ];
  int _selectedNecklaceIndex = 0;
  final Map<String, ui.Image> _imageCache = {};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadAssets();
    _meshDetector = FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
  }

  Future<void> _loadAssets() async {
    // Load Earrings (fixed for now)
    _earringImage = await _loadImage('assets/try_on/ears.png');
    
    // Load all necklaces
    for (String path in _necklaceAssets) {
      _imageCache[path] = await _loadImage(path);
    }
    
    _updateSelectedNecklace();
  }

  void _updateSelectedNecklace() {
    setState(() {
      _necklaceImage = _imageCache[_necklaceAssets[_selectedNecklaceIndex]];
    });
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void _initializeCamera() {
    // Select front camera
    final frontCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // Android optimized
    );

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
      _controller.startImageStream(_processCameraImage);
    });
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;
    _latestImage = image;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return;
      }

      final meshes = await _meshDetector.processImage(inputImage);
      if (mounted) {
        setState(() => _faceMeshes = meshes);
      }
    } catch (e) {
      debugPrint("Error detecting face mesh: $e");
    } finally {
      _isProcessing = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );
    
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation rotation = InputImageRotation.rotation0deg;

    if (Platform.isAndroid) {
      var rotationCompensation = _orientations[_controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation) ?? InputImageRotation.rotation0deg;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  static final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void dispose() {
    _controller.dispose();
    _meshDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Feed
          CameraPreview(_controller),

          // 2. AR Overlay (CustomPainter)
          if (_faceMeshes != null && _faceMeshes!.isNotEmpty)
            CustomPaint(
              painter: ARFacePainter(
                faceMesh: _faceMeshes!.first,
                necklaceImage: _necklaceImage,
                earringImage: _earringImage,
                neckYOffset: _neckYOffset,
                neckScale: _neckScale,
                category: widget.category
              ),
            ),

          // DEBUG OVERLAY
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                "Status: ${_isCameraInitialized ? 'Cam OK' : 'Cam Init...'}\n"
                "Assets: ${_necklaceImage != null ? 'Neck OK' : 'Neck Loading...'}\n"
                "Faces: ${_faceMeshes?.length ?? 0}\n"
                "Processing: $_isProcessing",
                style: const TextStyle(color: Colors.green, fontSize: 14),
              ),
            ),
          ),

          // 3. UI Controls
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   // Necklace Selector (Only for Necklaces)
                   if (widget.category.toLowerCase().contains('necklace') || widget.category.toLowerCase().contains('chain'))
                   SizedBox(
                     height: 60,
                     child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: _necklaceAssets.length,
                       itemBuilder: (context, index) {
                         final isSelected = _selectedNecklaceIndex == index;
                         return GestureDetector(
                           onTap: () {
                             setState(() {
                               _selectedNecklaceIndex = index;
                               _updateSelectedNecklace();
                             });
                           },
                           child: Container(
                             margin: const EdgeInsets.symmetric(horizontal: 8),
                             width: 50,
                             height: 50,
                             decoration: BoxDecoration(
                               border: isSelected ? Border.all(color: Colors.amber, width: 2) : null,
                               shape: BoxShape.circle,
                               image: DecorationImage(
                                 image: AssetImage(_necklaceAssets[index]),
                                 fit: BoxFit.cover,
                               ),
                             ),
                           ),
                         );
                       },
                     ),
                   ),
                   const SizedBox(height: 10),
                   
                   const Text("Adjust Position", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                   Row(
                     children: [
                       const Text("Height:", style: TextStyle(color: Colors.white)),
                       Expanded(
                         child: Slider(
                           value: _neckYOffset,
                           min: 0,
                           max: 400,
                           onChanged: (v) => setState(() => _neckYOffset = v),
                         ),
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       const Text("Scale:", style: TextStyle(color: Colors.white)),
                       Expanded(
                         child: Slider(
                           value: _neckScale,
                           min: 0.5,
                           max: 5.0,
                           onChanged: (v) => setState(() => _neckScale = v),
                         ),
                       ),
                     ],
                   ),
                   ElevatedButton(
                     onPressed: ()=> Navigator.pop(context), 
                     child: const Text("Close")
                   )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ARFacePainter extends CustomPainter {
  final FaceMesh faceMesh;
  final ui.Image? necklaceImage;
  final ui.Image? earringImage;
  final double neckYOffset;
  final double neckScale;
  final String category;

  ARFacePainter({
    required this.faceMesh,
    this.necklaceImage,
    this.earringImage,
    required this.neckYOffset,
    required this.neckScale,
    required this.category,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (necklaceImage == null && earringImage == null) return;

    final paint = Paint()..filterQuality = FilterQuality.high;
    final chin = faceMesh.points.firstWhere((p) => p.index == 152);
    final forehead = faceMesh.points.firstWhere((p) => p.index == 10);
    final faceHeight = (chin.y - forehead.y).abs();
    final renderScale = faceHeight * 0.005 * neckScale;

    bool isNecklace = category.toLowerCase().contains('necklace') || category.toLowerCase().contains('chain');
    bool isEarring = category.toLowerCase().contains('earring') || category.toLowerCase().contains('stud');

    // Draw Necklace
    if (isNecklace && necklaceImage != null) {
      final double necklaceX = chin.x.toDouble();
      final double necklaceY = chin.y.toDouble() + (faceHeight * 0.5) + neckYOffset;

      _drawImageCentered(
        canvas, 
        necklaceImage!, 
        Offset(necklaceX, necklaceY), 
        renderScale, 
        paint
      );
    }
    
    // Draw Earrings
    if (isEarring && earringImage != null) {
        try {
           final leftEar = faceMesh.points.firstWhere((p) => p.index == 401); 
           final rightEar = faceMesh.points.firstWhere((p) => p.index == 177);
           
           final double earYOffset = faceHeight * 0.1;
           final double earScale = renderScale * 0.5;

           _drawImageCentered(canvas, earringImage!, Offset(leftEar.x.toDouble(), leftEar.y.toDouble() + earYOffset), earScale, paint);
           _drawImageCentered(canvas, earringImage!, Offset(rightEar.x.toDouble(), rightEar.y.toDouble() + earYOffset), earScale, paint);
           
        } catch (e) {
           // Landmarks not found
        }
    }

    // DEBUG: Draw connection line and points
    final debugPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
      
    canvas.drawCircle(Offset(chin.x.toDouble(), chin.y.toDouble()), 10, debugPaint);
    canvas.drawCircle(Offset(forehead.x.toDouble(), forehead.y.toDouble()), 10, debugPaint);
  }

  void _drawImageCentered(Canvas canvas, ui.Image img, Offset center, double scale, Paint paint) {
    final double w = img.width.toDouble() * scale;
    final double h = img.height.toDouble() * scale;
    
    final Rect dstRect = Rect.fromCenter(center: center, width: w, height: h);
    final Rect srcRect = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    
    canvas.drawImageRect(img, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
