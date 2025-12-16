import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/global_variable.dart';
import 'package:vendor_store/models/vendor.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_store/provider/vendor_provider.dart';
import 'package:vendor_store/services/manage_http_respons.dart';
import 'package:vendor_store/views/screens/main_vendor_screen.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullname,
    required String email,
    required String password,
    required context,
  }) async {
    // Implementation for vendor sign-up
    try {
      Vendor vendor = Vendor(
        id: '',
        fullname: fullname,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signup'),
        body: vendor.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Handle the response as needed
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Account created successfully');
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  //function to login vendor
  Future<void> signInVendor({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String token = jsonEncode(jsonDecode(response.body)['token']);
          //save token to shared preferences
          await preferences.setString('auth_token', token);

          //encode user data received
          final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);

          //update the app state with user data using riverpod
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

          //store user data in shared preferences
          await preferences.setString('vendor', vendorJson);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainVendorScreen();
              },
            ),
            (route) => false,
          );
          showSnackbar(context, 'Login successful');
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
