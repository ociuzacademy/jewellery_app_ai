import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class TryOnScreen extends StatefulWidget {
  final String? initialNecklace;

  const TryOnScreen({super.key, this.initialNecklace});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
      _initController();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required for Try-On')),
        );
      }
    }
  }

  void _initController() {
    _controller = WebViewController(
      onPermissionRequest: (request) {
        request.grant();
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            if (widget.initialNecklace != null) {
              // We could inject logic here if needed to select a specific product
            }
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        debugPrint('WebView Console: ${message.message} (${message.level})');
      });
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    
    _loadHtmlFromAssets();
  }

  void _loadHtmlFromAssets() {
    _controller.loadFlutterAsset('assets/try_on/index.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Try-On'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          if (_hasPermission)
            WebViewWidget(controller: _controller)
          else
            const Center(child: Text('Camera permission required')),
          
          if (_isLoading && _hasPermission)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
