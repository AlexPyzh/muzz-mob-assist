import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/muzz_theme.dart';

class MainBottomNavigationBar extends StatefulWidget {
  const MainBottomNavigationBar({
    required this.currentTabIndex,
    required this.onTabTapped,
    super.key,
  });

  final int currentTabIndex;
  final void Function(int index) onTabTapped;

  @override
  State<MainBottomNavigationBar> createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: MuzzTheme.navBarDark,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: MuzzTheme.navBarUnselected,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentTabIndex,
      onTap: widget.onTabTapped,
      selectedFontSize: 10.0,
      unselectedFontSize: 10.0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: 30,
          ),
          activeIcon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.attach_money_outlined,
            size: 30,
          ),
          activeIcon: Icon(
            Icons.attach_money,
            size: 30,
          ),
          label: 'Invesments',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_music_outlined,
            size: 30,
          ),
          activeIcon: Icon(
            Icons.library_music,
            size: 30,
          ),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outlined,
            size: 30,
          ),
          activeIcon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'Me',
        ),
      ],
    );
  }
}
