import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

const _bgLight = 'assets/background/bg_light.png';
const _bgDark  = 'assets/background/bg_dark.png';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark ? _bgDark : _bgLight,
              fit: BoxFit.cover,
            ),
          ),
          IndexedStack(
            index: _tab.index,
            children: [
              HomeScreen(onTabChange: _switchTab),
              HistoryScreen(onTabChange: _switchTab),
              SettingsScreen(onTabChange: _switchTab),
            ],
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        active: _tab,
        onTap: _switchTab,
      ),
    );
  }
}
