import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendor_store/global_variable.dart';
import 'package:vendor_store/models/subcategory.dart';

class SubcategoryController {
  Future<List<Subcategory>> getSubcategoryBycategoryName(
    String categoryName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category/$categoryName/subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);

        final List<dynamic> data = jsonBody['subcategories']; // perbaikan
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        throw Exception('Subcategory not found for $categoryName');
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      return [];
    }
  }
}
