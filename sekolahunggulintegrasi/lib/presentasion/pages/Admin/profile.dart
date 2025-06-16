import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sekolah/presentasion/pages/role_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, String> _userData = {};
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  String? _token;
  final List<String> _validRoles = [
    'Admin',
    'Staff',
    'Sekolah',
    'Dinas',
    'Pelaksana',
    'Auditor',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token');
      print('Token: $_token'); // Debug token
      if (_token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Token autentikasi tidak ditemukan, silakan login ulang',
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RoleScreen()),
        );
        return;
      }
      _fetchProfileData();
    });
  }

  Future<void> _fetchProfileData() async {
    if (_token == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/users/profile'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userData = {
            'name': data['nama']?.toString() ?? '',
            'email': data['email']?.toString() ?? '',
            'role': data['role']?.toString() ?? '',
          };
          _nameController.text = _userData['name'] ?? '';
          _emailController.text = _userData['email'] ?? '';
          _roleController.text = _userData['role'] ?? '';
        });
      } else {
        throw Exception(
          'Gagal memuat profil: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateProfile() async {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token autentikasi tidak ditemukan')),
      );
      return;
    }

    if (!_validRoles.contains(_roleController.text)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Role tidak valid')));
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.217:3000/api/users/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'nama': _nameController.text,
          'email': _emailController.text,
          'role': _roleController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userData['name'] = _nameController.text;
          _userData['email'] = _emailController.text;
          _userData['role'] = _roleController.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        Navigator.pop(context);
      } else {
        throw Exception(
          'Gagal memperbarui profil: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  DropdownButtonFormField<String>(
                    value:
                        _roleController.text.isNotEmpty
                            ? _roleController.text
                            : null,
                    decoration: const InputDecoration(labelText: 'Jabatan'),
                    items:
                        _validRoles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _roleController.text = value ?? '';
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userData['name'] ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildProfileDetail('Email:', _userData['email'] ?? ''),
                    const SizedBox(height: 8),
                    _buildProfileDetail('Jabatan:', _userData['role'] ?? ''),
                    const SizedBox(height: 24),
                    _buildActionButton(
                      'Edit Profile',
                      Colors.green,
                      Icons.edit,
                      _showEditProfileDialog,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      'Logout',
                      Colors.blue,
                      Icons.logout,
                      () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('auth_token');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => RoleScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), const SizedBox(width: 8), Text(label)],
        ),
      ),
    );
  }
}
