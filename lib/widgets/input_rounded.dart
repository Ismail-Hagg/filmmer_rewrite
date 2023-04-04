import 'package:flutter/material.dart';

class InputRounded extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final Icon leading;
  final String hint;
  final TextInputType type;
  final TextEditingController controller;
  final bool isPass;
  final bool isTrailing;
  final Function()? flip;
  final TextInputAction action;
  final bool isIos;

  const InputRounded(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.textColor,
      required this.leading,
      required this.hint,
      required this.type,
      required this.controller,
      required this.isPass,
      required this.isTrailing,
      this.flip,
      required this.action,
      required this.isIos});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        vertical: height * 0.1,
      ),
      width: width * 0.9,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
          obscureText: isPass,
          controller: controller,
          textInputAction: action,
          style: TextStyle(
            color: textColor,
          ),
          cursorColor: textColor,
          keyboardType: type,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              suffixIcon: isTrailing
                  ? IconButton(
                      onPressed: flip,
                      icon: Icon(
                        isPass ? Icons.visibility_off : Icons.visibility,
                        color: textColor,
                      ),
                      splashRadius: 15,
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              icon: leading,
              hintText: hint,
              hintStyle: TextStyle(
                color: textColor,
              ),
              border: InputBorder.none)),
    );
  }
}
