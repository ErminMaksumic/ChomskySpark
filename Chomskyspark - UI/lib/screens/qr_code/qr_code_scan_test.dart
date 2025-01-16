import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/utils/auth_helper.dart';
import '../home/views/child_home_screen.dart';

class QrCodeScanTestPage extends StatefulWidget {
  const QrCodeScanTestPage({Key? key}) : super(key: key);


  @override
  _QrCodeScanTestPageState createState() => _QrCodeScanTestPageState();
}

class _QrCodeScanTestPageState extends State<QrCodeScanTestPage> {
  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR code from parent application'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Place your QR Code inside the frame to scan'),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                Authorization.user = await _userProvider.loginChild(1);
                Authorization.childLogged = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChildHomeScreen()),
                );
              },
              child: const Icon(Icons.qr_code_scanner, size: 250, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
