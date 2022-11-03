// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);
  final String payload;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(
            Icons.arrow_back_ios_new,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text(
                ' Hello, Osama',
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                ' You have a new reminder ',
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: primaryClr,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.text_format,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _payload.toString().split('|')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.description,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _payload.toString().split('|')[1],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    _payload.toString().split('|')[2],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      )),
    );
  }
}
