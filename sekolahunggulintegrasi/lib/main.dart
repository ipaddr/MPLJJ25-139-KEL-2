import 'package:flutter/material.dart';

import 'package:sekolahunggulintegrasi/presentasion/pages/home_screen.dart';

void main() {
  runApp(SekolahApp());
}

class SekolahApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Sekolah Unggul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // langsung ke HomeScreen
    );
  }
}
