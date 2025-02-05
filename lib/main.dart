import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:taski/data/repositories/task_repository.dart';
import 'package:taski/presentation/pages/home_page.dart';
import 'package:taski/presentation/providers/completed_task_provider.dart';
import 'package:taski/presentation/providers/find_task_provider.dart';
import 'package:taski/presentation/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider(TaskRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => CompletedTaskProvider(TaskRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => FindTaskProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          locale: const Locale('en'), 
          supportedLocales: const [
            Locale('en'),
            Locale('pt'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}
