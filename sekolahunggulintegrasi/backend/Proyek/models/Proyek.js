// models/Proyek.js
const mongoose = require('mongoose');

const proyekSchema = new mongoose.Schema({
  namaSekolah: { type: String, required: true },
  lokasi: { type: String, required: true },
  jadwal: { type: String, required: true },
  status: { type: String, required: true, enum: ['Berlangsung', 'Selesai'] },
  progressFisik: { type: Number, required: true, min: 0, max: 1 },
  progressKeuangan: { type: Number, required: true, min: 0, max: 1 },
});

module.exports = mongoose.model('Proyek', proyekSchema);