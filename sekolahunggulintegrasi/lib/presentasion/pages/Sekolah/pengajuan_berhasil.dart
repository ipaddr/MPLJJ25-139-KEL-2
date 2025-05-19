import 'package:flutter/material.dart';
import 'package:sekolahunggulintegrasi/presentasion/pages/Sekolah/status_proposal.dart';

class PengajuanBerhasil extends StatefulWidget {
  const PengajuanBerhasil({super.key});

  @override
  State<PengajuanBerhasil> createState() => _PengajuanProposalPageState();
}

class _PengajuanProposalPageState extends State<PengajuanBerhasil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Status Proposal'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Proposal Berhasil Diajukan!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Terima kasih. Proposal renovasi sudah dikirim ke Dinas Pendidikan. Silakan pantau statusnya secara berkala',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatusProposal()),
                );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  backgroundColor: Colors.blue,
                ),
                child: Text('Lihat Status Proposal'),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // Logika untuk kembali ke beranda
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  side: BorderSide(color: Colors.blue),
                ),
                child: Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}