import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const CustomButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 46, horizontal: 20),
        child: SizedBox(
          width: 300,
          height: 60,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(221, 26, 25, 25)),
            child: Text(title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
          ),
        ),
      ),
    );
  }
}
