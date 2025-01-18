import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:chomskyspark/providers/user_provider.dart';
import 'package:chomskyspark/screens/home/views/child_home_screen.dart';
import 'package:chomskyspark/utils/auth_helper.dart';

class QrCodeScanPage extends StatelessWidget {
  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR code from parent application"),
        centerTitle: true,
      ),
      body: Center(
        child: MobileScanner(
          onDetect: (capture) async {
            final List<Barcode> barcodes = capture.barcodes;
            final Barcode? barcode = barcodes.isNotEmpty ? barcodes.first : null;
            if (barcode != null) {
              print('Detected QR Code: ${barcode.rawValue}');
              int? intValue = int.tryParse(barcode.rawValue!);
              if (intValue != null){
                Authorization.user = await _userProvider.loginChild(1);
                Authorization.childLogged = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChildHomeScreen()),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
