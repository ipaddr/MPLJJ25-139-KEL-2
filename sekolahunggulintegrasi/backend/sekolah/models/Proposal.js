const mongoose = require('mongoose');
const proposalSchema = new mongoose.Schema({
  jenisProposal: {
    type: String,
    required: true,
    enum: [
      'Renovasi Bangunan',
      'Pembangunan Baru',
      'Penambahan Fasilitas',
      'Perbaikan Infrastruktur Penunjang (Jalan, Pagar, Toilet, Dll)'
    ],
  },
  judulProposal: {
    type: String,
    required: true,
  },
  namaSekolah: {
    type: String,
    required: true,
  },
  alamatSekolah: {
    type: String,
    required: true,
  },
  jumlahSiswa: {
    type: Number,
    required: true,
  },
  fasilitas: {
    type: String,
    required: true,
  },
  dokumenProposalPath: {
    type: String,
    required: true,
  },
  desainRencanaPath: {
    type: String,
    required: true,
  },
  dokumenRABPath: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    default: 'Menunggu',
    enum: ['Menunggu', 'Disetujui', 'Ditolak'],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Proposal', proposalSchema);