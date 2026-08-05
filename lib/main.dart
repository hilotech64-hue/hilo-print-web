import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const HiloPrintApp());
}

class HiloPrintApp extends StatelessWidget {
  const HiloPrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HILO PRINT',
      theme: AppTheme.theme,
      home: const HomePage(),
    );
  }
}