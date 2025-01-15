import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/utils/auth_helper.dart';

class GenerateQrPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect your child's device"),
        centerTitle: true,
      ),
      body: Center(
        child: QrImageView(
          data: "${Authorization.user!.id}",
          size: 280,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: const Size(
              100,
              100,
            ),
          ),
        ),
      ),
    );
  }
}
