import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:ecommerce_bnql/investor_panel/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/investor_panel/dashboard/dashboard_screen.dart';
import 'package:ecommerce_bnql/investor_panel/vendor/all_vendor_screen.dart';
import 'package:ecommerce_bnql/investor_panel/view_model/viewmodel_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
@override
  void initState() {
    Provider.of<UserViewModel>(context,listen: false).checkPermissions();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          animationDuration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          backgroundColor: Colors.grey.shade300,
          selectedIndex: _selectedIndex,
          showElevation: true,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.apps),
              title: const Text(' Dashboard'),
              activeColor: const Color(0xFFE56E14),
              inactiveColor: const Color(0xFF9898B0),
            ),
            BottomNavyBarItem(
                icon: const Icon(Icons.people),
                title: const Text(' Customers'),
                activeColor: const Color(0xFFE56E14),
                inactiveColor: const Color(0xFF9898B0)),
            BottomNavyBarItem(
                icon: const FaIcon(
                  FontAwesomeIcons.buildingColumns,
                  size: 20,
                ),
                title: const Text(' Investors'),
                activeColor: const Color(0xFFE56E14),
                inactiveColor: const Color(0xFF9898B0)),
          ],
        ),
        body: PageView(
          onPageChanged: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          controller: _pageController,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          children: const [
            DashboardInvestor(),
            AllCustomersScreen(),
            AllVendorScreen(),
          ],
        ),
      ),
    );
  }
}
