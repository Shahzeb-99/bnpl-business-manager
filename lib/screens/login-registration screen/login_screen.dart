import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/screens/login-registration%20screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_bnql/screens/login-registration screen/decorations.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autofocus: true,
              decoration: kDecoration.inputBox('Email'),
              controller: email,
            ),
            SizedBox(height: 5,),
            TextField(
              decoration: kDecoration.inputBox('Password'),
              obscureText: true,
              controller: password,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    auth
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text)
                        .then((value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllCustomersScreen())));
                  } on Exception catch (e) {
                    print(e);
                  }
                },
                child: Text('Login')),
            Row(
              children: [
                Text('Dont have an account?'),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()));
                  },
                  child: Text(
                    '  Sign up',
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
