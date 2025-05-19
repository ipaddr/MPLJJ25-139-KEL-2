import 'package:flutter/material.dart';
import 'package:sekolah/presentasion/pages/role_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bapak Arif',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Dinas Pendidikan - Provinsi Jawa Tengah',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'budi.pelaksana@email.com'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Proyek Aktif: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Renovasi SDN 3 Sejahtera'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Aksi edit profile
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => RoleScreen()),
                            (route) =>
                                false, // Menghapus semua route sebelumnya
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
