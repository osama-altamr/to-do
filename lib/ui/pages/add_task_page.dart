import 'package:flutter/material.dart';
import 'package:to_do/controllers/task_controller.dart';
import 'package:to_do/ui/theme.dart';
import 'package:to_do/ui/widgets/button.dart';
import 'package:to_do/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  // ignore: prefer_final_fields
  DateTime _selectedDate = DateTime.now();
  // ignore: prefer_final_fields
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  // ignore: prefer_final_fields
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  int _selectedColor = 0;

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter titel here.',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here.',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        color: Colors.grey,
                        icon: const Icon(
                          Icons.access_alarm_rounded,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        color: Colors.grey,
                        icon: const Icon(
                          Icons.access_alarm_rounded,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Row(
                  children: [
                    DropdownButton<int>(
                      borderRadius: BorderRadius.circular(10),
                      items: remindList
                          .map(
                            (element) => DropdownMenuItem(
                              value: element,
                              child: Text(
                                '$element',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      style: subTitleStyle,
                      elevation: 4,
                      underline: Container(height: 0),
                      onChanged: (int? value) {
                        setState(() {
                          _selectedRemind = value!;
                        });
                      },
                      dropdownColor: Colors.blueGrey,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton<String>(
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      },
                      items: repeatList
                          .map(
                            (String element) => DropdownMenuItem(
                              value: element,
                              child: Text(
                                element,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      dropdownColor: Colors.blueGrey,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: subTitleStyle,
                      iconSize: 32,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                      onTap: () {
                        _validateData();
                      },
                      lable: 'Create Task')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions: const [
        CircleAvatar(
          radius: 19,
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDatabase();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'required',
        'All Fields are required!',
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
        colorText: pinkClr,
        backgroundColor: Colors.white,
      );
    } else {
      debugPrint('########## SOMTHING BAD HAPPENED #########');
    }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2016),
        lastDate: DateTime(2100));

    if (_pickedDate != null)
      setState(() => _selectedDate = _pickedDate);
    else
      print('It\'s null or something is wrong');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                Duration(minutes: 15),
              ),
            ),
    );
    if (_pickedTime != null) {
      String _formattedTime = _pickedTime.format(context);
      if (isStartTime)
        setState(() => _startTime = _formattedTime);
      else if (!isStartTime)
        setState(() => _endTime = _formattedTime);
      else
        debugPrint('time canceld or something is wrong ');
    } else
      debugPrint('time canceld or something is wrong ');
  }

  _addTaskToDatabase() async {
    try {
      var value = await _taskController.addTask(
          task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ));
      print("$value");
    } catch (e) {
      print(e);
    }
  }
}
