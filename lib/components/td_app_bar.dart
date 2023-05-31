import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../resources/app_color.dart';

class TdAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TdAppBar({
    super.key,
    this.rightPressed,
    required this.title,
    this.color = AppColor.bgColor,
    this.icon = const Icon(Icons.logout, size: 24.0, color: AppColor.brown),
  });

  final VoidCallback? rightPressed;
  final String title;
  final Color color;
  final Icon icon;

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
          InkWell(
            onTap: rightPressed,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Transform.rotate(
              angle: 45 * (math.pi / 180),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 4.6, right: 4.6, bottom: 8.0),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.shadow,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: -45 * (math.pi / 180),
                  child: icon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
