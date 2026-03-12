import 'package:flutter/material.dart';
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/jewellery_list/model/gold_jewel_model.dart';
import 'package:jewellery_app/view/user_module/jewellery_list/service/gold_jewel_service.dart';
import 'package:jewellery_app/view/user_module/single_product/page/user_single_product.dart';

class JewelryPage extends StatefulWidget {
  final int category_id;

  const JewelryPage({super.key, required this.category_id});

  @override
  _JewelryPageState createState() => _JewelryPageState();
}

class _JewelryPageState extends State<JewelryPage> {
  String selectedCategory = "All";
  final List<String> categories = ["All", "Bangles", "Necklaces", "Rings", "Chains"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jewellery", style: TextStyle(color: Colors.deepPurple)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal List for Categories
            SizedBox(
              height: size.height * 0.06,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: ChoiceChip(
                      label: Text(categories[index], style: const TextStyle(color: Colors.deepPurple)),
                      selected: selectedCategory == categories[index],
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                      },
                      selectedColor: Colors.deepPurple.shade100,
                      backgroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: size.height * 0.02),

            // Fetching Data using FutureBuilder
            Expanded(
              child: FutureBuilder<List<ProductListModel>>(
                future: productList(category_id: widget.category_id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}", style: const TextStyle(fontSize: 18, color: Colors.black54)),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No items found", style: TextStyle(fontSize: 18, color: Colors.black54)));
                  }

                  // Filtering Items
                  List<ProductListModel> filteredItems = snapshot.data!.where((item) {
                    return selectedCategory == "All" || item.subcategory == selectedCategory;
                  }).toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLandscape ? 3 : 2,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.width * 0.03,
                      childAspectRatio: size.width / (size.height * 0.8),
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return JewelryItem(
                        product: filteredItems[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Jewelry Item Widget with Gesture Detection
class JewelryItem extends StatelessWidget {
  final ProductListModel product;

  const JewelryItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JewelryProductPage(productId: product.id!.toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  '${UserUrl.baseUrl}/${product.mainImage!}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(product.name!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  SizedBox(height: size.height * 0.005),
                  Text("\$${product.price!}", style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}