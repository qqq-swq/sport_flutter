import 'package:flutter/material.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/pages/community_page.dart';
import 'package:sport_flutter/presentation/pages/profile_page.dart';
import 'package:sport_flutter/presentation/pages/videos_page.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // By creating the pages here and not marking them as 'const', we ensure
  // they are instantiated once and get a correct BuildContext.
  // Using 'late' defers initialization until they are first accessed.
  late final List<Widget> _widgetOptions = [
    const VideosPage(),
    const CommunityPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home),
            activeIcon: const Icon(Iconsax.home_2),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.people),
            activeIcon: const Icon(Iconsax.profile_2user),
            label: l10n.community, 
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.profile),
            activeIcon: const Icon(Iconsax.user_octagon),
            label: l10n.profile, 
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
