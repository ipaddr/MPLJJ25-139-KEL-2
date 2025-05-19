import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/Admin/dashboard_admin.dart';
import 'package:sekolah/presentasion/pages/DinasPendidikan/dashboard_dinas.dart';
import 'package:sekolah/presentasion/pages/Sekolah/dashboard_sekolah.dart';

// Import semua dashboard sesuai role




class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final role = widget.role;

    // Simulasi login sederhana
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    // Navigasi ke dashboard berdasarkan role

    if (role == 'Sekolah') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardSekolah()),
      );
    } else if (role == 'Dinas') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardDinas(),
        ), // Asumsikan ada DashboardDinas
      );
    }else if (role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardAdmin(),
        ), // Asumsikan ada DashboardDinas
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Role tidak dikenal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login sebagai ${widget.role}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            Text("Password", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _handleLogin,
                child: const Text('Log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
