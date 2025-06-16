// controllers/progressController.js
const Progress = require('../models/Progress');

const createProgress = async (req, res) => {
  try {
    const { minggu, fisik, keuangan, catatan } = req.body;
    const fotoPath = req.file ? `/uploads/${req.file.filename}` : null;

    const progress = new Progress({
      minggu,
      fisik: parseFloat(fisik),
      keuangan: parseFloat(keuangan),
      fotoPath,
      catatan,
    });

    await progress.save();
    res.status(201).json({ message: 'Progress berhasil diupload', progress });
  } catch (error) {
    res.status(500).json({ message: 'Error uploading progress', error: error.message });
  }
};

const getAllProgress = async (req, res) => {
  try {
    const progressList = await Progress.find().sort({ createdAt: -1 }); // Urutkan berdasarkan terbaru
    res.status(200).json(progressList);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching progress list', error: error.message });
  }
};
module.exports = { createProgress, getAllProgress };