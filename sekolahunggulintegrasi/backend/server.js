const express = require('express');
const app = express();
const connectDB = require('./config/db');
const sekolahRoutes = require('./sekolah/routes/sekolahRoutes');
const proyekRoutes = require('./Proyek/routes/proyekRoutes');
const progressRoutes = require('./Proyek/routes/progressRoutes');
const auditRoutes = require('./Proyek/routes/auditRoutes');
const pdfRoutes = require('./Proyek/routes/pdf');
const proposalRoutes = require('./sekolah/routes/proposalRoutes');
const userRoutes = require('./admin/routes/user');
const cors = require('cors');
const path = require('path');
const User = require('./admin/models/User'); // Pastikan path sesuai
const bcrypt = require('bcryptjs');



// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/api/sekolah', sekolahRoutes);
app.use('/api', proposalRoutes);
app.use('/api', proyekRoutes);
app.use('/api', progressRoutes);
app.use('/api', auditRoutes);
app.use('/api/users', userRoutes);
app.use('/api/generate-pdf', pdfRoutes);

// DB Connect & Run Server
connectDB().then(async () => {
  console.log('MongoDB connected');

  // Inisialisasi Admin pertama jika belum ada
  const adminCount = await User.countDocuments({ role: 'Admin' });
  if (adminCount === 0) {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    await User.create({
      id: 'ADM1',
      nama: 'Admin Utama',
      email: 'admin@example.com',
      role: 'Admin',
      status: 'Aktif',
      password: hashedPassword,
    });
    console.log('Admin pertama telah dibuat.');
  }

  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
}).catch(err => {
  console.error('MongoDB connection error:', err);
});