import 'package:flutter/material.dart';
import 'package:sekolahunggulintegrasi/presentasion/pages/login_screen.dart'; // Pastikan import sesuai lokasi file LoginScreen

class RoleScreen extends StatelessWidget {
  RoleScreen({super.key});

  final List<String> roles = [
    'Admin',
    'Sekolah',
    'Dinas',
    'Pelaksana',
    'Auditor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hak Akses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...roles.map(
              (role) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(role: role),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    child: Text(role, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Home Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
