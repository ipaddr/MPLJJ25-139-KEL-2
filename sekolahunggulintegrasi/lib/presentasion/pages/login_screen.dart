import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sekolah/presentasion/pages/Admin/dashboard_admin.dart';
import 'package:sekolah/presentasion/pages/Auditor/dashboard_auditor.dart';
import 'package:sekolah/presentasion/pages/DinasPendidikan/dashboard_dinas.dart';
import 'package:sekolah/presentasion/pages/Pelaksana/dashboard_pelaksana.dart';
import 'package:sekolah/presentasion/pages/Sekolah/dashboard_sekolah.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.217:3000/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final role = data['user']['role'].toString().toLowerCase();

        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        // Tentukan dashboard berdasarkan role
        Widget dashboard;
        switch (role) {
          case 'sekolah':
            if (widget.role.toLowerCase() == 'sekolah') {
              dashboard = const DashboardSekolah();
            } else {
              _showAccessDenied();
              return;
            }
            break;
          case 'dinas':
            if (widget.role.toLowerCase() == 'dinas') {
              dashboard = const DashboardDinas();
            } else {
              _showAccessDenied();
              return;
            }
            break;
          case 'admin':
            if (widget.role.toLowerCase() == 'admin') {
              dashboard = DashboardAdmin(token: token);
            } else {
              _showAccessDenied();
              return;
            }
            break;
          case 'pelaksana':
            if (widget.role.toLowerCase() == 'pelaksana') {
              dashboard = const DashboardPelaksana();
            } else {
              _showAccessDenied();
              return;
            }
            break;
          case 'auditor':
            if (widget.role.toLowerCase() == 'auditor') {
              dashboard = const DashboardAuditor();
            } else {
              _showAccessDenied();
              return;
            }
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Role tidak dikenali')),
            );
            return;
        }

        // Pindah ke dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => dashboard),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login gagal: ${errorData['message'] ?? 'Cek kredensial'}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAccessDenied() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda tidak memiliki akses ke dashboard ini'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login sebagai ${widget.role}'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Icon(Icons.lock, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  'Masuk sebagai ${widget.role}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Masukkan email',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Masukkan password',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.blue,
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
