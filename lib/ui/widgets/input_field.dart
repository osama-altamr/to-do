import 'package:flutter/material.dart';
import '../theme.dart';
import '../size_config.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
              padding: const EdgeInsets.only(left: 14),
              margin: const EdgeInsets.only(top: 8),
              height: 52,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget != null ? true : false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).backgroundColor,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).backgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ]),
            ),
          ],
        ));
  }
}
