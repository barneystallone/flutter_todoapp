import 'package:flutter/material.dart';

class AuthTextFieldGroup extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String hintText;
  final String? errText;
  final bool obscureText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Color iconColor = const Color.fromRGBO(150, 150, 150, 1);
  final VoidCallback? toggleShowHide;
  final void Function()? onChanged;
  const AuthTextFieldGroup(
      {super.key,
      required this.text,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      this.errText,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.toggleShowHide});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(150, 150, 150, 1),
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: obscureText,
            controller: controller,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            onChanged: (value) {
              onChanged!();
            },
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                prefixIcon: prefixIcon,
                prefixIconColor: iconColor,
                suffixIcon: suffixIcon != null
                    ? GestureDetector(onTap: toggleShowHide, child: suffixIcon)
                    : null,
                suffixIconColor: iconColor,
                errorText: errText,
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                fillColor: const Color.fromRGBO(240, 240, 240, 1),
                filled: true,
                border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40)))),
          )
        ],
      ),
    );
  }
}
