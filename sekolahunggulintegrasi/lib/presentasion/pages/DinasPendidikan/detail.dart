import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Proyek'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'SMP Harapan Jaya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Dalam proses',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Jenis Proyek: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'Renovasi Gedung Sekolah'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text('Minggu ke: 4'),
              const SizedBox(height: 12),

              // Progress Fisik
              const Text(
                'Progress Fisik: 55%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: 0.55,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
              const SizedBox(height: 12),

              // Progress Keuangan
              const Text(
                'Progress Keuangan: 47%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: 0.47,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
              const SizedBox(height: 16),

              // Foto Progress
              Row(
                children: const [
                  Expanded(child: FotoProgressButton()),
                  SizedBox(width: 8),
                  Expanded(child: FotoProgressButton()),
                  SizedBox(width: 8),
                  Expanded(child: FotoProgressButton()),
                ],
              ),

              const SizedBox(height: 24),

              // Kembali Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Kembali Ke Monitoring',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FotoProgressButton extends StatelessWidget {
  const FotoProgressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Tambahkan aksi jika perlu
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade800,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text('Foto progress'),
    );
  }
}
