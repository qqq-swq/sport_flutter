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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    // By moving the list creation inside the build method and using a key,
    // we ensure that VideosPage is rebuilt when the language changes.
    final List<Widget> widgetOptions = [
      VideosPage(key: ValueKey('videos_${locale.languageCode}')), // Add key to force rebuild
      const CommunityPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
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
