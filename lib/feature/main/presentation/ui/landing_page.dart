import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({required this.child, super.key});

  final Widget child;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  static const List<(String label, String route, IconData icon)>
  _navigationItems = [
    ('Home', Routes.home, Icons.home_outlined),
    ('Docs', Routes.docs, Icons.article_outlined),
    ('Profile', Routes.profile, Icons.person_outline),
  ];

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _currentIndex = index;
    });
    context.goNamed(_navigationItems[index].$2);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: widget.child,
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: DsColors.overlay,
            blurRadius: DsSizing.size8,
            offset: Offset(0, -DsSizing.size2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: _navigationItems
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.$3),
                selectedIcon: Icon(item.$3),
                label: item.$1,
              ),
            )
            .toList(),
      ),
    ),
  );
}
