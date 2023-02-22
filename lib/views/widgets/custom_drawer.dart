import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/services/theme/theme_services.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Icon?> thumbIcon =
    MaterialStateProperty.resolveWith<Icon?>(
          (Set<MaterialState> states) {
        // Thumb icon when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.dark_mode);
        }
        return const Icon(Icons.light_mode);
      },
    );

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              child: const Text("Kanban Board", style: TextStyle(fontSize: 30,),textAlign: TextAlign.center,),),
          Card(
            color: Get.theme.cardColor,
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text("Settings"),
            ),
          ),
          ListTile(
              title: const Text('Theme change'),
              trailing: Switch(
                thumbIcon: thumbIcon,
                value: ThemeService().loadThemeFromBox(),
                onChanged: (val) {
                  ThemeService().switchTheme();
                },
                activeColor: Theme.of(context).colorScheme.primary,
              )),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
