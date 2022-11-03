import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:to_do/ui/widgets/button.dart';
import 'package:to_do/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';

import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import 'add_task_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    _taskController.getTasks();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // NotifyHelper().initializeNotification();
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 8,
            ),
            _showTasks(),
          ],
        ));
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
        onPressed: () {
          ThemeServices().switchTheme();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            _alertDialog();
          ;
          },
          icon: Icon(
            Icons.cleaning_services_outlined,
            size: 27,
          ),
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
        const SizedBox(
          width: 18,
        ),
        const CircleAvatar(
          radius: 19,
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _alertDialog() {
    Get.defaultDialog(
        title: 'Delete All Tasks ',
        titlePadding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 2),
        middleText: 'Do you want to delete all Tasks ?',
        middleTextStyle: subTitleStyle,
        // // content: Container(width:80,height:50,padding: EdgeInsets.all(70),
        // // child: Column(children: [
        // //   Text('Delete All Tasks ',style: titleStyle,),
        // //   Text('Do you want to delete all Tasks ?',style: subTitleStyle,),
        // ]),),
        // content: Container(
        //   child: Column(children: [
        //     Text('Osamaa is a developer '),
        //     Text('Osamaa is a developer '),
        //   ]),
        // ),

        backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
        radius: 20,
        titleStyle: titleStyle,
        actions: [
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(' Confirm '),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryClr),
              elevation: MaterialStateProperty.all(3),
              shadowColor: MaterialStateProperty.all(darkGreyClr),
            ),
            onPressed: () {
              _taskController.deleteAllTask();
              notifyHelper.cancelAllNotification();
              Get.back();
            },
          ),
          SizedBox(
            width: 16,
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(' Cancel '),
            ),
            style: ButtonStyle(
              // padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20,vertical: 6)),
              elevation: MaterialStateProperty.all(3),
              shadowColor: MaterialStateProperty.all(darkGreyClr),
              backgroundColor: MaterialStateProperty.all(Colors.red[400]),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ]);
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              'Todey',
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks();
            },
            lable: '+ Add Task')
      ]),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 6),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty)
            return noTaskMsg();
          else
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                  scrollDirection:
                      SizeConfig.orientation == Orientation.landscape
                          ? Axis.horizontal
                          : Axis.vertical,
                  itemCount: _taskController.taskList.length,
                  itemBuilder: (ctx, index) {
                    var task = _taskController.taskList[index];

                    if (task.repeat == 'Daily' ||
                        task.date == DateFormat.yMd().format(_selectedDate) ||
                        (task.repeat == 'Weekly' &&
                            _selectedDate
                                        .difference(
                                            DateFormat.yMd().parse(task.date!))
                                        .inDays %
                                    7 ==
                                0) ||
                        (task.repeat == 'Monthly' &&
                            DateFormat.yMd().parse(task.date!).day ==
                                _selectedDate.day)) {
                      var date = DateFormat.jm().parse(task.startTime!);
                      debugPrint(date.toString());
                      var myTime = DateFormat('HH:mm').format(date);
                      debugPrint(' MyTime ${date}');
                      NotifyHelper().scheduledNotification(
                        int.parse(myTime.toString().split(':')[0]),
                        int.parse(myTime.toString().split(':')[1]),
                        task,
                      );
                      return AnimationConfiguration.staggeredList(
                          duration: Duration(milliseconds: 1370),
                          position: index,
                          child: SlideAnimation(
                            horizontalOffset: 200,
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  showBottomSheet(
                                    context,
                                    task,
                                  );
                                },
                                child: TaskTile(
                                  task,
                                ),
                              ),
                            ),
                          ));
                    } else {
                      return Container();
                    }
                  }),
            );
        },
      ),
    );
  }

  noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 190,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    semanticsLabel: 'Task',
                    height: 100,
                    color: primaryClr.withOpacity(0.6),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet! \n Add new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 170,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showBottomSheet(BuildContext ctx, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: SizeConfig.orientation == Orientation.landscape
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(children: [
          Flexible(
            child: Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheet(
                  label: 'Task Completed',
                  onTap: () {
                    notifyHelper.cancelNotification(task);
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: primaryClr,
                ),
          _buildBottomSheet(
            label: 'delete Task ',
            onTap: () {
              notifyHelper.cancelNotification(task);
              _taskController.deleteTask(task);
              Get.back();
            },
            clr: Colors.red[400]!,
          ),
          Divider(
            color: Get.isDarkMode ? Colors.grey : darkGreyClr,
          ),
          _buildBottomSheet(
            label: 'Cancel',
            onTap: () {
              Get.back();
            },
            clr: primaryClr,
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClosed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          color: isClosed ? Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClosed
                ? (Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!)
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          label,
          style: isClosed
              ? titleStyle
              : titleStyle.copyWith(
                  color: Colors.white,
                ),
        )),
      ),
    );
  }
}
