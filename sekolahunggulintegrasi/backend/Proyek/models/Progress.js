// models/Progress.js
const mongoose = require('mongoose');

const progressSchema = new mongoose.Schema({
  minggu: { type: String, required: true },
  fisik: { type: Number, required: true, min: 0, max: 100 }, // Persentase 0-100
  keuangan: { type: Number, required: true, min: 0, max: 100 }, // Persentase 0-100
  fotoPath: { type: String }, // Path ke file foto yang diupload
  catatan: { type: String },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Progress', progressSchema);