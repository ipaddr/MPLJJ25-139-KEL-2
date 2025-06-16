const Proyek = require('../models/Proyek');
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

// Mendapatkan semua proyek
const getAllProyek = async (req, res) => {
  try {
    const proyek = await Proyek.find();
    res.status(200).json(proyek);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching proyek', error: error.message });
  }
};

// Menambahkan proyek baru
const createProyek = async (req, res) => {
  const { namaSekolah, lokasi, jadwal, status, progressFisik, progressKeuangan } = req.body;
  const newProyek = new Proyek({
    namaSekolah,
    lokasi,
    jadwal,
    status,
    progressFisik,
    progressKeuangan,
  });
  try {
    const savedProyek = await newProyek.save();
    res.status(201).json(savedProyek);
  } catch (error) {
    res.status(400).json({ message: 'Error creating proyek', error: error.message });
  }
};

// Memperbarui progress proyek
const updateProyekProgress = async (req, res) => {
  const { progressFisik, progressKeuangan } = req.body;
  try {
    const updatedProyek = await Proyek.findByIdAndUpdate(
      req.params.id,
      { progressFisik, progressKeuangan },
      { new: true, runValidators: true }
    );
    if (!updatedProyek) return res.status(404).json({ message: 'Proyek not found' });
    res.status(200).json(updatedProyek);
  } catch (error) {
    res.status(400).json({ message: 'Error updating proyek', error: error.message });
  }
};

// Menandai proyek sebagai selesai
const markProyekAsCompleted = async (req, res) => {
  try {
    const updatedProyek = await Proyek.findByIdAndUpdate(
      req.params.id,
      { status: 'Selesai', progressFisik: 1, progressKeuangan: 1 },
      { new: true, runValidators: true }
    );
    if (!updatedProyek) return res.status(404).json({ message: 'Proyek not found' });
    res.status(200).json(updatedProyek);
  } catch (error) {
    res.status(400).json({ message: 'Error marking proyek as completed', error: error.message });
  }
};

// Menghasilkan PDF untuk proyek
const generateProyekPDF = async (req, res) => {
  try {
    const proyekId = req.params.id;
    const proyek = await Proyek.findById(proyekId);

    if (!proyek) {
      return res.status(404).json({ message: 'Proyek tidak ditemukan' });
    }

    const tempDir = path.join(__dirname, '../temp');
    if (!fs.existsSync(tempDir)) fs.mkdirSync(tempDir);
    const pdfFilePath = path.join(tempDir, `proyek_${proyekId}.pdf`);

    const doc = new PDFDocument({ margin: 50 });
    doc.pipe(fs.createWriteStream(pdfFilePath));

    // Tambahkan judul
    doc.fontSize(16).text('Laporan Proyek', { align: 'center' });
    doc.moveDown();

    // Definisikan tabel
    const table = {
      headers: ['Kategori', 'Detail'],
      rows: [
        ['Nama Sekolah', proyek.namaSekolah],
        ['Lokasi', proyek.lokasi],
        ['Jadwal', proyek.jadwal],
        ['Status', proyek.status],
        ['Progress Fisik', `${(proyek.progressFisik * 100).toFixed(2)}%`],
        ['Progress Keuangan', `${(proyek.progressKeuangan * 100).toFixed(2)}%`],
      ],
    };

    // Atur posisi dan lebar kolom
    const columnWidths = [150, 300];
    const startX = 50;
    let startY = 100;

    // Gambar header tabel
    doc.fontSize(12).font('Helvetica-Bold');
    doc.text(table.headers[0], startX, startY, { width: columnWidths[0], align: 'left' });
    doc.text(table.headers[1], startX + columnWidths[0], startY, { width: columnWidths[1], align: 'left' });
    doc.moveTo(startX, startY + 20).lineTo(startX + columnWidths[0] + columnWidths[1], startY + 20).stroke();

    // Gambar baris data
    doc.font('Helvetica');
    let currentY = startY + 30;
    table.rows.forEach(row => {
      doc.text(row[0], startX, currentY, { width: columnWidths[0], align: 'left' });
      doc.text(row[1], startX + columnWidths[0], currentY, { width: columnWidths[1], align: 'left' });
      currentY += 20;
    });

    // Gambar garis bawah tabel (opsional)
    doc.moveTo(startX, currentY + 5).lineTo(startX + columnWidths[0] + columnWidths[1], currentY + 5).stroke();

    doc.end();

    setTimeout(() => {
      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader('Content-Disposition', `attachment; filename="proyek_${proyekId}.pdf"`);
      res.sendFile(pdfFilePath, (err) => {
        if (err) {
          res.status(500).json({ message: 'Error mengirim file PDF', error: err.message });
        }
        // Hapus file setelah dikirim
        fs.unlinkSync(pdfFilePath);
      });
    }, 1000);
  } catch (error) {
    res.status(500).json({ message: 'Error processing request', error: error.message });
  }
};

module.exports = { getAllProyek, createProyek, updateProyekProgress, markProyekAsCompleted, generateProyekPDF };