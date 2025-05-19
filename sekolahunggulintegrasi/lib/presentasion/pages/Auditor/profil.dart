import 'package:flutter/material.dart';

class ProfilAuditor extends StatelessWidget {
  const ProfilAuditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Profil Auditor'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('Bu Rina', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Auditor Lapangan'),
            const SizedBox(height: 16),
            const Text('Email: rina.audit@kemendikbud.go.id'),
            const Text('Wilayah: Provinsi Jawa Barat'),
            const Text('ID Pegawai: AUD-27811'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
