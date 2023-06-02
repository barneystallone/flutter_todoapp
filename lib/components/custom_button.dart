import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomButton extends StatelessWidget {
  final String title;
  const CustomButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 46, horizontal: 20),
        child: SizedBox(
          width: 300,
          height: 60,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(221, 26, 25, 25)),
          ),
        ),
      ),
    );
  }
}
