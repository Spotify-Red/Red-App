import 'package:flutter/material.dart';
import 'package:spotify_red_app/core/configs/theme/app_colors.dart';

class BasicNavBar extends StatefulWidget {
  const BasicNavBar({super.key});

  @override
  State<StatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends State<BasicNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: AppColors.primary,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home),
          label: 'Feed',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_music),
          label: 'Library',
        ),
        NavigationDestination(
          icon: Icon(Icons.portrait_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}