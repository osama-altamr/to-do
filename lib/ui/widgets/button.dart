import 'package:flutter/material.dart';
import 'package:to_do/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.onTap,
    required this.lable,
  }) : super(key: key);
  final Function() onTap;
  final String lable;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        child: Text(
          lable,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
