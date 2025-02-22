import 'package:flutter/material.dart';
import 'package:spotify_red_app/common/helpers/is_dark.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget ? title;
  const BasicAppbar({
    this.title,
    super.key
});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: context.isDarkMode ? Colors.white.withAlpha(8) : Colors.black.withAlpha(9),
            shape: BoxShape.circle
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        )
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}