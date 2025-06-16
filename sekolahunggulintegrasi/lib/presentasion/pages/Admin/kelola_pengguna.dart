import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KelolaPengguna extends StatefulWidget {
  final String? token;

  const KelolaPengguna({super.key, this.token});

  @override
  State<KelolaPengguna> createState() => _KelolaPenggunaState();
}

class _KelolaPenggunaState extends State<KelolaPengguna> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    print('Token di KelolaPengguna: ${widget.token}'); // Debug token
    if (widget.token == null || widget.token!.isEmpty) {
      print('Error: Token is null or empty, login mungkin gagal.');
    }
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.217:3000/api/users'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      print('Respons API Fetch: ${response.body}'); // Debug respons
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _users =
                data
                    .cast<
                      Map<String, dynamic>
                    >(); // Konversi ke List<Map<String, dynamic>>
          });
        } else {
          setState(() {
            _users = []; // Set ke list kosong jika bukan List
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Respons bukan daftar pengguna')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat pengguna: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.217:3000/api/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(userData),
      );
      print('Respons API Create: ${response.body}'); // Debug respons
      if (response.statusCode == 201) {
        _fetchUsers(); // Refresh daftar pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna berhasil ditambahkan')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan pengguna: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateUser(String id, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.18.217:3000/api/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode(userData),
      );
      print('Respons API Update: ${response.body}'); // Debug respons
      if (response.statusCode == 200) {
        _fetchUsers(); // Refresh daftar pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui pengguna: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.18.217:3000/api/users/$id'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      print('Respons API Delete: ${response.body}'); // Debug respons
      if (response.statusCode == 200) {
        _fetchUsers(); // Refresh daftar pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus pengguna: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelola Pengguna',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manajemen akun pengguna dalam sistem',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.blue[50]),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'ID/NIP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Role',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Aksi',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows:
                          _users.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(Text(user['id']?.toString() ?? '')),
                                DataCell(Text(user['nama']?.toString() ?? '')),
                                DataCell(Text(user['email']?.toString() ?? '')),
                                DataCell(Text(user['role']?.toString() ?? '')),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          user['status'] == 'Aktif'
                                              ? Colors.green
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      user['status']?.toString() ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _updateUser(user['id'].toString(), {
                                            'nama': user['nama'],
                                            'email': user['email'],
                                            'role': user['role'],
                                            'status': user['status'],
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap:
                                            () => _deleteUser(
                                              user['id'].toString(),
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 10, color: Colors.blue, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                final idController = TextEditingController();
                final namaController = TextEditingController();
                final emailController = TextEditingController();
                String? role;
                String? status;
                final passwordController = TextEditingController();

                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Tambah Pengguna'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: idController,
                                decoration: const InputDecoration(
                                  labelText: 'ID/NIP',
                                ),
                              ),
                              TextField(
                                controller: namaController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama',
                                ),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: role,
                                items:
                                    [
                                          'Admin',
                                          'Staff',
                                          'Sekolah',
                                          'Dinas',
                                          'Pelaksana',
                                          'Auditor',
                                        ]
                                        .map(
                                          (r) => DropdownMenuItem(
                                            value: r,
                                            child: Text(r),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (value) => setState(() => role = value),
                                decoration: const InputDecoration(
                                  labelText: 'Role',
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: status,
                                items:
                                    ['Aktif', 'Tidak Aktif']
                                        .map(
                                          (s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(s),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (value) => setState(() => status = value),
                                decoration: const InputDecoration(
                                  labelText: 'Status',
                                ),
                              ),
                              TextField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (idController.text.isNotEmpty &&
                                  namaController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  role != null &&
                                  status != null &&
                                  passwordController.text.isNotEmpty) {
                                _createUser({
                                  'id': idController.text,
                                  'nama': namaController.text,
                                  'email': emailController.text,
                                  'role': role,
                                  'status': status,
                                  'password': passwordController.text,
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua field wajib diisi'),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            },
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
