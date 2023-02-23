import 'package:flutter/material.dart';
import 'package:kanban_board_app/services/theme/theme_services.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [Switch(
        thumbIcon: thumbIcon,
        value: ThemeService().loadThemeFromBox(),
        onChanged: (val) {
          ThemeService().switchTheme();
        },
        activeColor: Theme.of(context).colorScheme.primary,
      )],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text("Kanban Board")],
      ),
      centerTitle: true,
    );
  }
}
