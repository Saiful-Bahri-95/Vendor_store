import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store/controllers/category_controller.dart';
import 'package:vendor_store/models/category.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late Future<List<Category>> futureCategories;
  late String name;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  //create an instance of image picker
  final ImagePicker picker = ImagePicker();

  //initialize an empty list to store the selected images
  List<File> images = [];

  //define a function to pick from the galery
  chooseImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      print('No image selected');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: images.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    )
                  : SizedBox(
                      width: 50,
                      height: 40,
                      child: Image.file(images[index - 1], fit: BoxFit.cover),
                    );
            },
          ),
          SizedBox(
            width: 200,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter Product Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Product Price',
                hintText: 'Enter Product Price',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 100,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter Quantity',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No categories found");
              }

              final categories = snapshot.data!;

              return Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<Category>(
                  value: selectedCategory,
                  hint: Text("Select Category"),
                  isExpanded: true,
                  underline: SizedBox(),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              );
            },
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: TextFormField(
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: 'Product Description',
                hintText: 'Enter Product Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
