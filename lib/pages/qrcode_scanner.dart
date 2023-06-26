import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  String ticket = '';
  List<String> tickets = [];

  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );

    Future<void> registerPresence(String token) async {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('https://qtivate-backend-nydo5yvida-uc.a.run.app/api/v1/presence');
      final headers = {"aid": prefs.getString('ra'), "mac": prefs.getString('mac'), 'token': token};
      final response = await post(url, headers: headers);
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      // _handleResponse(response);
      setState(() => ticket = code != '-1' ? response.body : 'Não validado');
    }
    registerPresence(code); //fazer a requisição

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/puc80anos.png',
              fit: BoxFit.contain,
              width: 260,
              height: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            if (ticket != '')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '$ticket',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 100,
                  width: 300, // specific value
                  child: ElevatedButton.icon(
                    onPressed: readQRCode,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Presença', style: TextStyle(fontSize: 24),),
                  ),),
            ),
          ],
        ),
      ),
    );
  }
}
