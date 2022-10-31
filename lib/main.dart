import 'package:ecommerce_bnql/investor_panel/pageview_screen.dart';
import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'company_panel/view_model/viewmodel_customers.dart';
import 'company_panel/view_model/viewmodel_dashboard.dart';
import 'company_panel/view_model/viewmodel_vendors.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'investor_panel/view_model/viewmodel_customers.dart';
import 'investor_panel/view_model/viewmodel_vendors.dart';

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
        ChangeNotifierProvider(create: (context) => VendorView()),
        ChangeNotifierProvider(create: (context) => CustomerView()),
        ChangeNotifierProvider(create: (context) => DashboardView()),
        ChangeNotifierProvider(create: (context)=>DashboardViewInvestor()),
        ChangeNotifierProvider(create: (context)=>VendorViewInvestor()),
        ChangeNotifierProvider(create: (context)=>CustomerViewInvestor()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
              primaryColor: const Color(0xFFE8C8D2),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF9898B0),
                secondary: Color(0xFF2D2C3F),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: Colors.white, //<-- SEE HERE
                displayColor: Colors.white,
              ),
              scaffoldBackgroundColor: const Color(0xFF1A1C33),
              drawerTheme: const DrawerThemeData(
                backgroundColor: Color(0xFF2D2C3F),
              ),
              appBarTheme: const AppBarTheme(
                elevation: 3,
                color: Color(0xFF1A1C33),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
          home: const MainScreen()),
    );
  }
}
