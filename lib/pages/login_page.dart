import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get_mac/get_mac.dart';
import 'package:qtivate/main.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;
import 'package:qtivate/pages/qrcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mongodb.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _raController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isHidden = true;

  // função para pegar o macaddress
  Future<void> initMacAddress() async {
    String macAddress;

    try {
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      macAddress = 'Error getting the MAC address.';
    }
    print(macAddress);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mac', macAddress.toString());
  }

  @override
  Widget build(BuildContext context) {
    initMacAddress();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(
                  //   Icons.phone_android,
                  //   size: 100,
                  // ),
                  Image.asset(
                    'lib/assets/puc80anos.png',
                    fit: BoxFit.contain,
                    width: 260,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  const Text(
                    'Seja bem-vindo!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  //email tect
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _raController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Seu RA',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Senha',
                            suffixIcon: IconButton(
                              icon: _isHidden == true
                                  ? const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              )
                                  : const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordView,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //sign
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Material(
                      color: const Color.fromARGB(255, 43, 43, 160),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Center(
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('powered by Qtivate'),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void signIn() async {
    final prefs = await SharedPreferences.getInstance();
    bool valid;
    valid = await MongoDatabase.checkLogin(
        _raController.text, _passwordController.text);
    if (valid == true) {
      await prefs.setString('ra', _raController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('isLoggedIn', true);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QrScanner()),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login e/ou senha está incorreto'),
            duration: const Duration(milliseconds: 1500),
            width: 280.0,
            // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
      );
    }
  }
}
