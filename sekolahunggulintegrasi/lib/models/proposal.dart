// lib/models/proposal.dart
class Proposal {
  final String id;
  final String jenisProposal;
  final String judulProposal;
  final String namaSekolah;
  final String alamatSekolah;
  final int jumlahSiswa;
  final String fasilitas;
  final String dokumenProposalPath;
  final String desainRencanaPath;
  final String dokumenRABPath;
  final String status;
  final DateTime createdAt;

  Proposal({
    required this.id,
    required this.jenisProposal,
    required this.judulProposal,
    required this.namaSekolah,
    required this.alamatSekolah,
    required this.jumlahSiswa,
    required this.fasilitas,
    required this.dokumenProposalPath,
    required this.desainRencanaPath,
    required this.dokumenRABPath,
    required this.status,
    required this.createdAt,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['_id'],
      jenisProposal: json['jenisProposal'],
      judulProposal: json['judulProposal'],
      namaSekolah: json['namaSekolah'],
      alamatSekolah: json['alamatSekolah'],
      jumlahSiswa: json['jumlahSiswa'],
      fasilitas: json['fasilitas'],
      dokumenProposalPath: json['dokumenProposalPath'],
      desainRencanaPath: json['desainRencanaPath'],
      dokumenRABPath: json['dokumenRABPath'],
      status: json['status'] ?? 'Menunggu',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}