import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:shop/providers/file_provider.dart';
import 'package:shop/providers/language_provider.dart';
//import 'package:shop/providers/file_provider%20copy.dart';
import 'package:shop/providers/user_provider.dart'; // Import your UserProvider
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Thanks for using our template. You are using the free version of the template.
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Template by The Flutter Way',
      theme: AppTheme.lightTheme(context),
      // Dark theme is inclided in the Full template
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute:  kidsScreenRoute,
    );
  }
}
