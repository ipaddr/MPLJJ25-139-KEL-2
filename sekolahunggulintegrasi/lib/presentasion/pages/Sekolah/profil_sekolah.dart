import 'package:flutter/material.dart';
import 'package:sekolahunggulintegrasi/presentasion/pages/role_screen.dart';

class ProfilSekolahPage extends StatelessWidget {
  const ProfilSekolahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: Colors.blue[700],
          child: const Center(
            child: Text(
              '👤 Profil Sekolah',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileItem("Nama Sekolah:", "SD Negeri Harapan Bangsa"),
              profileItem("NPSN:", "12345678"),
              profileItem("Jenjang:", "SD"),
              profileItem("Alamat:", "Jl. Pendidikan No. 5, Jakarta"),
              profileItem("Jumlah Siswa:", "250"),
              profileItem("Fasilitas:", "Perpustakaan, Lab Komputer, UKS"),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(width: 12),
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
                      (route) => false, // Menghapus semua route sebelumnya
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget profileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(text: value, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
