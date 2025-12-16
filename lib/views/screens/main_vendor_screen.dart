import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_store/views/screens/nav_screens/earning_screen.dart';
import 'package:vendor_store/views/screens/nav_screens/edit_screen.dart';
import 'package:vendor_store/views/screens/nav_screens/order_screen.dart';
import 'package:vendor_store/views/screens/nav_screens/profile_screen.dart';
import 'package:vendor_store/views/screens/nav_screens/upload_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;

  List<Widget> pages = [
    EarningScreen(),
    UploadScreen(),
    EditScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purple,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar),
            label: 'Ernings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.upload_circle),
            label: 'Upload',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
