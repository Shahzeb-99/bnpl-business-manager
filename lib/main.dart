import 'package:ecommerce_bnql/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/view_model/viewmodel_customers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomerView()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: Colors.black, //<-- SEE HERE
                displayColor: Colors.black,
              ),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(elevation: 0,
                  color: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  )),
          home: const AllCustomersScreen()),
    );
  }
}
