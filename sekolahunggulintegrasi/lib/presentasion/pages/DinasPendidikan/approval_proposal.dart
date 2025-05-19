import 'package:flutter/material.dart';

class Approvalproposal extends StatefulWidget {
  const Approvalproposal({super.key});

  @override
  State<Approvalproposal> createState() => _ApprovalproposalState();
}

class _ApprovalproposalState extends State<Approvalproposal> {
  String? _selectedAction;

  final List<String> _actions = [
    'Setuju dan kirim ke pusat',
    'Tolak dan kembalikan ke sekolah',
  ];

  void _submitAction() {
    if (_selectedAction != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aksi dipilih: $_selectedAction'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih aksi terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📄 Approval Proposal Renovasi'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Informasi proposal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔍 Proposal dari SD Negeri 2 Sukamaju',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Jenis Proposal: Renovasi'),
                  Text('Alamat: Jl. Raya No. 12, Sukamaju'),
                  Text('Jumlah Siswa: 500'),
                  SizedBox(height: 8),
                  Text(
                    'Fasilitas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• Ruang kelas, Lapangan, Kantin'),
                  SizedBox(height: 8),
                  Text(
                    'Desain Rencana Renovasi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('RAB Proposal'),
                  Text('Download RAB'),
                  SizedBox(height: 8),
                  Text(
                    'Catatan:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Perbaikan beberapa fasilitas yang sudah rusak dan pembaharuan ruang kelas.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown Aksi Proposal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 Pilih Aksi Proposal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Pilih Aksi:'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedAction,
                    hint: const Text('Aksi Proposal'),
                    items: _actions
                        .map((action) => DropdownMenuItem(
                              value: action,
                              child: Text(action),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAction = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
