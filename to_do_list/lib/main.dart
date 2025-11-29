import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/core/size_config.dart';
import 'package:to_do_list/pages/home_page.dart';

void main() async {
  // init hive
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}
