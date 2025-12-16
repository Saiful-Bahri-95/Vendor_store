import 'package:flutter_riverpod/legacy.dart';
import 'package:vendor_store/models/vendor.dart';

//state notifier to hold vendor data
//managing the state, it's also designed to notify listeners about state changes
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
    : super(
        Vendor(
          id: '',
          fullname: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          role: '',
          password: '',
        ),
      );

  //getter method to extract vendor data
  Vendor? get vendor => state;

  //method to set vendor user state from Json data
  //purpose: update the vendor state when new data is available
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  //method to clear vendor data on sign out
  void signOut() {
    state = null;
  }
}

//make the provider accessible throughout the app
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>(
  (ref) => VendorProvider(),
);
