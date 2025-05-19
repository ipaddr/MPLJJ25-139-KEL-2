import 'package:flutter/material.dart';

class KelolaPengguna extends StatefulWidget {
  const KelolaPengguna({super.key});

  @override
  State<KelolaPengguna> createState() => _KelolaPenggunaState();
}

class _KelolaPenggunaState extends State<KelolaPengguna> {
  // Sample data for user management
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'USR1',
      'nama': 'Andi Purnama',
      'email': 'andi@example.com',
      'role': 'Super Admin',
      'status': 'Aktif',
    },
    {
      'id': 'USR2',
      'nama': 'Santi',
      'email': 'santi@mail.com',
      'role': 'Staff',
      'status': 'Tidak Aktif',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Table section
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
                      rows: _users.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(Text(user['id'])),
                            DataCell(Text(user['nama'])),
                            DataCell(Text(user['email'])),
                            DataCell(Text(user['role'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: user['status'] == 'Aktif' ? Colors.green : Colors.grey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user['status'],
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
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

          // Bottom blue bar for consistency with the design
          Container(
            height: 10,
            color: Colors.blue,
            width: double.infinity,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add new user
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}