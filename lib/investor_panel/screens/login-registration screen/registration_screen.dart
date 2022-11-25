
import 'package:ecommerce_bnql/investor_panel/pageview_screen.dart';
import 'package:ecommerce_bnql/investor_panel/screens/login-registration%20screen/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_bnql/investor_panel/screens/login-registration screen/decorations.dart';
import 'package:provider/provider.dart';

import '../../view_model/viewmodel_user.dart';



class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/dart.png',scale: 3,),
            TextField(
              decoration: kDecoration.inputBox('Email'),
              autofocus: true,
              controller: email,
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              decoration: kDecoration.inputBox('Password'),
              obscureText: true,
              controller: password,
            ),
            ElevatedButton(
                onPressed: () {
                  try {
                    auth.createUserWithEmailAndPassword(
                        email: email.text, password: password.text).then((value) async {
                      Provider.of<UserViewModel>(context,listen: false)
                          .checkPermissions()
                          .whenComplete(() => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen())));
                    });
                  } on Exception catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Text('Register')),
            Row(
              children: [
                const Text('Already have an account?'),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) =>   LoginScreen()));
                  },
                  child: const Text(
                    '  Sign in',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
