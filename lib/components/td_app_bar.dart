import 'package:flutter/material.dart';
import '../resources/app_color.dart';

class TdAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TdAppBar({
    super.key,
    this.rightPressed,
    required this.title,
    this.color = AppColor.bgColor,
  });

  final VoidCallback? rightPressed;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0)
          .copyWith(top: MediaQuery.of(context).padding.top + 4.6, bottom: 8.0),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
            radius: 24.0,
          ),
          Text(title,
              style: const TextStyle(color: AppColor.blue, fontSize: 22.0)),
          PopupMenuButton(
              icon: const Icon(Icons.menu),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        value: 0,
                        height: 30,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.logout,
                              size: 16.0,
                              color: AppColor.brown,
                            ),
                            SizedBox(width: 12.0),
                            Expanded(child: Text('Logout')),
                          ],
                        )),
                    PopupMenuItem(
                        padding: const EdgeInsets.all(8),
                        value: 0,
                        height: 30,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.restore_from_trash,
                              size: 16.0,
                              color: AppColor.brown,
                            ),
                            SizedBox(width: 12.0),
                            Expanded(child: Text('Restore')),
                          ],
                        )),
                  ])
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
