import 'package:flutter/material.dart';
import 'package:posts_app/core/app_theme.dart';
import 'package:posts_app/features/posts/presentation/screens/posts_screen.dart';
import 'package:posts_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      title: 'Posts App',
      home: const PostsScreen(),
    );
  }
}
