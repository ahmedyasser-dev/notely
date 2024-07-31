import 'package:flutter/material.dart';
import 'package:notely2/components/drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //header
          DrawerHeader(
            child: Icon(
              Icons.event_note,
              size: 60,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          //note tile
          DrawerTile(
            title: 'Notes',
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          //settings tile
          DrawerTile(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () {
              //pop the menu drawer
              Navigator.pop(context);
              //navigate to the settings page
              Navigator.pushNamed(context, '/settingspage');
            },
          ),
        ],
      ),
    );
  }
}
