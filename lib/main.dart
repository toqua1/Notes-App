import 'package:flutter/material.dart';
import 'package:notesapp/sqldb.dart';
import 'HomePage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SqlDb.createDatabase();
 // SqlDb.mydeleteDatabase() ;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier=ValueNotifier(ThemeMode.dark) ;
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (_,ThemeMode currentMode, __){
          return MaterialApp(
            title: 'Flutter Demo',
            home: Home(),
            theme: ThemeData(
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            debugShowCheckedModeBanner: false,
          );
        }) ;

  }
}
