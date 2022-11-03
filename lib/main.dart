import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/db/db_helper.dart';
import 'package:to_do/ui/pages/home_page.dart';
import 'services/theme_services.dart';
import 'ui/theme.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();

  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
    );
  }
}
