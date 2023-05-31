import 'package:flutter/material.dart';
import '../resources/app_color.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadow,
            offset: Offset(0.0, 3.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: AppColor.grey),
          prefixIcon: Icon(Icons.search, color: AppColor.black),
          prefixIconConstraints: BoxConstraints(minWidth: 28.0),
        ),
      ),
    );
  }
}
