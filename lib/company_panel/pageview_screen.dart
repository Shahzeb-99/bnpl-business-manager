import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:ecommerce_bnql/company_panel/customer/all_customer_screen.dart';
import 'package:ecommerce_bnql/company_panel/dashboard/dashboard_screen.dart';
import 'package:ecommerce_bnql/company_panel/vendor/all_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreenCustomer extends StatefulWidget {
  const MainScreenCustomer({Key? key}) : super(key: key);

  @override
  State<MainScreenCustomer> createState() => _MainScreenCustomerState();
}

class _MainScreenCustomerState extends State<MainScreenCustomer> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

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
          backgroundColor: const Color(0xFF1C1E38),
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
              activeColor: const Color(0xFF9191E7),
              inactiveColor: const Color(0xFF9898B0),
            ),
            BottomNavyBarItem(
                icon: const Icon(Icons.people),
                title: const Text(' Customers'),
                activeColor: const Color(0xFF9191E7),
                inactiveColor: const Color(0xFF9898B0)),
            BottomNavyBarItem(
                icon: const FaIcon(
                  FontAwesomeIcons.shop,
                  size: 20,
                ),
                title: const Text(' Vendors'),
                activeColor: const Color(0xFF9191E7),
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
          children:   [
            DashboardCompany(),
            const AllCustomersScreen(),
            const AllVendorScreen(),
          ],
        ),
      ),
    );
  }
}
