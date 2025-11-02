import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<(String label, IconData icon)> _navigationItems = [
    ('Home', Icons.home_outlined),
    ('Docs', Icons.article_outlined),
    ('Profile', Icons.person_outline),
  ];

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: DsColors.navigationBarShadow,
            blurRadius: DsSizing.size8,
            offset: Offset(0, -DsSizing.size2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: _navigationItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.$2),
                selectedIcon: Icon(item.$2),
                label: item.$1,
              ),
            )
            .toList(),
      ),
    ),
  );
}
