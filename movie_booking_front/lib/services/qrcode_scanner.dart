import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  final List qrcodedata;
  const QrCodeScanner({super.key, required this.qrcodedata});

  @override
  State<QrCodeScanner> createState() => _QrcodeScannerState();
}

class _QrcodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController _cameraController = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;
        if (widget.qrcodedata.contains(code)) {
          _cameraController.stop();

          // Show dialog
          _showMatchedDialog(code);
        }
        break;
      }
    }
  }

  void _showMatchedDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Matched"),
          content: Text('QR Code Detection: $code'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cameraController.start();
              },
              child: const Text("Start Scan Again"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code Scanner")),
      body: MobileScanner(controller: _cameraController, onDetect: _onDetect),
    );
  }
}
