import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  NavTab _tab = NavTab.home;

  void _switchTab(NavTab tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab.index,
        children: [
          HomeScreen(onTabChange: _switchTab),
          HistoryScreen(onTabChange: _switchTab),
          SettingsScreen(onTabChange: _switchTab),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        active: _tab,
        onTap: _switchTab,
      ),
    );
  }
}
