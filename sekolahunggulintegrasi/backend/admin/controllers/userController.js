const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching users', error: error.message });
  }
};

const createUser = async (req, res) => {
  const { id, nama, email, role, status, password } = req.body;

  if (!id || !nama || !email || !role || !status || !password) {
    return res.status(400).json({ message: 'Semua field wajib diisi.' });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ id, nama, email, role, status, password: hashedPassword });
    const savedUser = await newUser.save();
    res.status(201).json({ message: 'Pengguna berhasil ditambahkan', user: savedUser });
  } catch (error) {
    res.status(400).json({ message: 'Error creating user', error: error.message });
  }
};

const updateUser = async (req, res) => {
  const { id, nama, email, role, status, password } = req.body;
  try {
    const updatedUser = await User.findOneAndUpdate(
      { id: req.params.id },
      { nama, email, role, status, ...(password && { password: await bcrypt.hash(password, 10) }) },
      { new: true, runValidators: true }
    );
    if (!updatedUser) return res.status(404).json({ message: 'Pengguna tidak ditemukan' });
    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(400).json({ message: 'Error updating user', error: error.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    const deletedUser = await User.findOneAndDelete({ id: req.params.id });
    if (!deletedUser) return res.status(404).json({ message: 'Pengguna tidak ditemukan' });
    res.status(200).json({ message: 'Pengguna berhasil dihapus' });
  } catch (error) {
    res.status(400).json({ message: 'Error deleting user', error: error.message });
  }
};

const loginUser = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email dan password wajib diisi.' });
  }

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ message: 'Email tidak ditemukan.' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ message: 'Password salah.' });

    if (user.status !== 'Aktif') {
      return res.status(403).json({ message: 'Akun tidak aktif.' });
    }

    const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.status(200).json({ message: 'Login berhasil', token, user: { id: user.id, nama: user.nama, role: user.role, status: user.status } });
  } catch (error) {
    res.status(500).json({ message: 'Error logging in', error: error.message });
  }
};

const getProfile = async (req, res) => {
  try {
    const user = await User.findOne({ id: req.user.id }); // Ambil dari JWT payload
    console.log('user dari token:', req.user);
    if (!user) return res.status(404).json({ message: 'Pengguna tidak ditemukan' });

    // Hanya kembalikan nama, email, dan role
    res.status(200).json({
      nama: user.nama,
      email: user.email,
      role: user.role,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error mengambil profil', error: error.message });
  }
};


const updateProfile = async (req, res) => {
  const { nama, email, role } = req.body;

  try {
    const user = await User.findOne({ id: req.user.id });
    if (!user) return res.status(404).json({ message: 'Pengguna tidak ditemukan' });

    // Validasi role
    if (!['Admin', 'Staff', 'Sekolah', 'Dinas', 'Pelaksana', 'Auditor'].includes(role)) {
      return res.status(400).json({ message: 'Role tidak valid' });
    }

    user.nama = nama || user.nama;
    user.email = email || user.email;
    user.role = role || user.role;

    const updatedUser = await user.save();
    res.status(200).json({
      message: 'Profil berhasil diperbarui',
      nama: updatedUser.nama,
      email: updatedUser.email,
      role: updatedUser.role,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error memperbarui profil', error: error.message });
  }
};
module.exports = { getAllUsers, createUser, updateUser, deleteUser, loginUser, getProfile, updateProfile };