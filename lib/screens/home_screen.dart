import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/calendar.dart';
import 'package:flutter_application_3/screens/selfcare.dart';
import 'package:flutter_application_3/screens/profile_screen.dart';
import 'package:flutter_application_3/screens/home_screen2.dart';
import 'package:flutter_application_3/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  List<Widget> pages = [
    const MainScreen(),
    const Calendar(),
    const Selfcare(),
    const ProfileScreen(),
  ];

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: pages[_page],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.calendar_month, "Calendar", 1),
              _buildNavItem(Icons.favorite, "SelfCare", 2),
              _buildNavItem(Icons.account_circle_rounded, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _page == index;
    return GestureDetector(
      onTap: () => onPageChange(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 20 : 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.pinkAccent.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.black : primaryColor),
            if (isSelected) ...[
              SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }
}
