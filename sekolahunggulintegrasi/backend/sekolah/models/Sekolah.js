const mongoose = require('mongoose');

const sekolahSchema = new mongoose.Schema({
  nama: { type: String, required: true },
  npsn: { type: String, required: true, unique: true },
  alamat: { type: String, required: true },
  jenjang: { type: String, required: true },
  jumlahSiswa: { type: Number, required: true },
  fasilitas: { type: [String], default: [] },
  dokumentasi: { type: [String], default: [] },
  statusVerifikasi: { type: String, enum: ['draft', 'menunggu_verifikasi', 'disetujui', 'ditolak'], default: 'draft' }, // Perbarui enum
  catatan: { type: String, default: '' },
}, { timestamps: true });

module.exports = mongoose.model('Sekolah', sekolahSchema);