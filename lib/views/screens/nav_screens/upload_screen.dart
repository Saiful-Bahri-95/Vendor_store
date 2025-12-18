import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store/controllers/category_controller.dart';
import 'package:vendor_store/controllers/subcategory_controller.dart';
import 'package:vendor_store/models/category.dart';
import 'package:vendor_store/models/subcategory.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;
  Category? selectedCategory;
  Subcategory? selectedSubcategory;

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

  getSubcategoryByCategory(value) {
    futureSubcategories = SubcategoryController().getSubcategoryBycategoryName(
      value.name,
    );
    selectedSubcategory =
        null; // ⬅️ reset selected subcategory when category changes
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product name';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product price';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter quantity';
                  }
                  return null;
                },
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
                        selectedSubcategory = null; // ⬅️ WAJIB RESET
                        futureSubcategories = SubcategoryController()
                            .getSubcategoryBycategoryName(value!.name);
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Subcategory>>(
              future: futureSubcategories,
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

                final subcategories = snapshot.data!;

                return Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButton<Subcategory>(
                    value: selectedSubcategory,
                    hint: Text("Select Subcategory"),
                    isExpanded: true,
                    underline: SizedBox(),
                    items: subcategories.map((subcategory) {
                      return DropdownMenuItem(
                        value: subcategory,
                        child: Text(subcategory.subCategoryName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubcategory = value;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product description';
                  }
                  return null;
                },
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
            InkWell(
              onTap: () {
                //upload product function here
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  print('uploaded');
                } else {
                  print('Please Enter all fields');
                }
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(10),
                  // gradient: LinearGradient(
                  //   colors: [Colors.blue.shade900, Colors.blue.shade700],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                ),
                child: Center(
                  child: Text(
                    'UPLOAD PRODUCT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
