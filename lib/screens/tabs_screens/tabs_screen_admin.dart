import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sickle_cell_app/providers/user_provider.dart';
import 'package:sickle_cell_app/screens/home_screens/home_screen_admin.dart';
import 'package:sickle_cell_app/screens/profile/profile_screen.dart';

class TabsScreenAdmin extends ConsumerStatefulWidget {
  const TabsScreenAdmin({super.key});

  @override
  ConsumerState<TabsScreenAdmin> createState() => _TabsScreenAdminState();
}

class _TabsScreenAdminState extends ConsumerState<TabsScreenAdmin> {
  int _selectedScreenIndex = 0;
  String? userId;

  List<IconData> navIcons = [
    Icons.home_outlined,
    Icons.person_outlined,
    // Icons.menu,
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    Widget activeScreen = HomeScreenAdmin();

    if (_selectedScreenIndex == 1) {
      activeScreen = ProfileScreen(
        userDetails: user!,
      );
    }
    // if (_selectedScreenIndex == 2) {
    //   activeScreen = MoreScreen();
    // }
    return Scaffold(
      body: Stack(
        children: [
          activeScreen,
          Align(alignment: Alignment.bottomCenter, child: _navBar(context)),
        ],
      ),
    );
  }

  Widget _navBar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 90,
      margin: EdgeInsets.only(
        right: screenWidth * 0.25,
        left: screenWidth * 0.25,
        bottom: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(44),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 30,
            spreadRadius: 15,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcons.map((icon) {
          int index = navIcons.indexOf(icon);
          bool isSelected = _selectedScreenIndex == index;

          return Flexible(
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  _selectScreen(index);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromARGB(100, 158, 158, 158),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.black,
                    size: screenWidth * 0.08, // Icon size
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
