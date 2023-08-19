import 'package:flutter/material.dart';
import 'package:fwitter/features/auth/views/login_view.dart';
import 'package:fwitter/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginView(),
    );
  }
}
