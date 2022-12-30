import 'package:ecommerce_bnql/investor_panel/screens/login-registration%20screen/login_screen.dart';
import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_dashboard.dart';
import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_user.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
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
        ChangeNotifierProvider(create: (context) => DashboardViewInvestor()),
        ChangeNotifierProvider(create: (context) => VendorViewInvestor()),
        ChangeNotifierProvider(create: (context) => CustomerViewInvestor()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),

      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
              primaryColor: Colors.white,
              colorScheme:  const ColorScheme.light(
                primary:    Color(0xFFE56E14),
                secondary:    Color(0xFFE56E14),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ).apply(
                bodyColor: const Color(0xFFE56E14),
                displayColor:  const Color(0xFFE56E14),
              ),
              scaffoldBackgroundColor: Colors.white,
              drawerTheme: const DrawerThemeData(
                backgroundColor: Colors.white,
              ),
              appBarTheme:   const AppBarTheme(

                elevation: 3,
                color: Colors.white,
                iconTheme: IconThemeData(color: Color(0xFFE56E14),),
              ),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
          home: LoginScreen()),
    );
  }
}
