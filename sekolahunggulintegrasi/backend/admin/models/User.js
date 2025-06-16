const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true }, // ID/NIP
  nama: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  role: { 
    type: String, 
    enum: ['Admin', 'Staff', 'Sekolah', 'Dinas', 'Pelaksana', 'Auditor'], 
    required: true 
  },
  status: { type: String, enum: ['Aktif', 'Tidak Aktif'], required: true },
  password: { type: String, required: true }, // Di-hash dengan bcrypt
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);