import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const NavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'หน้าแรก',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'จอง'),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'แผนที่',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'แต้ม'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'โปรไฟล์',
        ),
      ],
    );
  }
}
