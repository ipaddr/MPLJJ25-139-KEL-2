import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/home_screen.dart';
// import halaman lain jika sudah dibuat

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => HomeScreen(),
    // '/dashboard': (context) => DashboardPage(),
    // '/input-sekolah': (context) => InputDataSekolahPage(),
    // dst.
  };
}
