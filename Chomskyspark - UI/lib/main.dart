import 'package:chomskyspark/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chomskyspark/providers/file_provider.dart';
import 'package:chomskyspark/providers/language_provider.dart';
import 'package:chomskyspark/providers/user_provider.dart'; // Import your UserProvider
import 'package:chomskyspark/providers/word_for_image_provider.dart';
import 'package:chomskyspark/providers/image_generator_provider.dart';
import 'package:chomskyspark/route/route_constants.dart';
import 'package:chomskyspark/route/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance(); // Initialize shared_preferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => WordForImageProvider()),
        ChangeNotifierProvider(create: (_) => ImageGeneratorProvider()),
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
      title: 'Chomskyspark',
      theme: AppTheme.lightTheme(context),
      // Dark theme is inclided in the Full template
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: logInScreenRoute,
    );
  }
}
