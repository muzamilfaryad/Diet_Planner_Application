import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

/// Barcode scanner service
/// Note: Barcode scanning temporarily disabled for Android v2 embedding migration
/// Will be re-enabled with mobile_scanner widget implementation
class BarcodeScannerService {
  /// Placeholder for barcode scanning
  /// Note: Use MobileScanner widget directly in UI
  Future<String?> scanBarcode() async {
    if (kDebugMode) {
      print('Barcode scanning temporarily disabled');
      print('Use MobileScanner widget directly in UI for now');
    }
    return null;
  }

  /// Check if barcode scanning is supported on current platform
  bool isSupported() {
    // Barcode scanning works best on mobile platforms
    return !kIsWeb;
  }
}
