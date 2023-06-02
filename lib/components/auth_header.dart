import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 26),
      child: Center(
        child: Stack(
          children: [
            Text(
              title,
              style: const TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            Positioned(
              bottom: 7,
              left: 1,
              child: Container(
                  width: 24,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1.8, color: Colors.blue.shade300),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(3)))),
            )
          ],
        ),
      ),
    );
  }
}
