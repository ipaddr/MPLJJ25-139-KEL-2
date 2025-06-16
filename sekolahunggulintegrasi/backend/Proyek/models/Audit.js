// models/Audit.js
const mongoose = require('mongoose');

const auditSchema = new mongoose.Schema({
  namaProyek: { type: String, required: true },
  danaAwal: { type: Number, required: true },
  pengeluaranMingguIni: { type: Number, required: true },
  totalPengeluaran: { type: Number, required: true },
  totalRab: { type: Number, required: true },
  catatanAuditor: { type: String },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Audit', auditSchema);