const Audit = require('../models/Audit');
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

const createAudit = async (req, res) => {
  try {
    const { namaProyek, danaAwal, pengeluaranMingguIni, totalPengeluaran, totalRab, catatanAuditor } = req.body;

    if (!namaProyek || !danaAwal || !pengeluaranMingguIni || !totalPengeluaran || !totalRab) {
      return res.status(400).json({ message: 'Semua field wajib diisi kecuali catatan auditor.' });
    }

    const audit = new Audit({
      namaProyek,
      danaAwal: parseFloat(danaAwal),
      pengeluaranMingguIni: parseFloat(pengeluaranMingguIni),
      totalPengeluaran: parseFloat(totalPengeluaran),
      totalRab: parseFloat(totalRab),
      catatanAuditor,
    });

    await audit.save();
    res.status(201).json({ message: 'Laporan audit berhasil disimpan', audit });
  } catch (error) {
    res.status(500).json({ message: 'Error menyimpan laporan audit', error: error.message });
  }
};

const getAllAudit = async (req, res) => {
  try {
    const auditList = await Audit.find().sort({ createdAt: -1 });
    res.status(200).json(auditList);
  } catch (error) {
    res.status(500).json({ message: 'Error mengambil data audit', error: error.message });
  }
};

const generateAuditPDF = async (req, res) => {
  try {
    const auditId = req.params.id;
    const audit = await Audit.findById(auditId);

    if (!audit) {
      return res.status(404).json({ message: 'Laporan audit tidak ditemukan' });
    }

    const tempDir = path.join(__dirname, '../temp');
    if (!fs.existsSync(tempDir)) fs.mkdirSync(tempDir);
    const pdfFilePath = path.join(tempDir, `audit_${auditId}.pdf`);

    const doc = new PDFDocument({ margin: 50 });
    doc.pipe(fs.createWriteStream(pdfFilePath));

    // Tambahkan judul
    doc.fontSize(16).text('Laporan Audit Proyek', { align: 'center' });
    doc.moveDown();

    // Definisikan tabel
    const table = {
      headers: ['Kategori', 'Detail'],
      rows: [
        ['Nama Proyek', audit.namaProyek],
        ['Dana Awal', `Rp ${audit.danaAwal.toLocaleString('id-ID')}`],
        ['Pengeluaran Minggu Ini', `Rp ${audit.pengeluaranMingguIni.toLocaleString('id-ID')}`],
        ['Total Pengeluaran', `Rp ${audit.totalPengeluaran.toLocaleString('id-ID')}`],
        ['Total RAB', `Rp ${audit.totalRab.toLocaleString('id-ID')}`],
        ['Catatan Auditor', audit.catatanAuditor || 'Tidak ada catatan'],
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
      res.setHeader('Content-Disposition', `attachment; filename="audit_${auditId}.pdf"`);
      res.sendFile(pdfFilePath, (err) => {
        if (err) {
          res.status(500).json({ message: 'Error mengirim file PDF', error: err.message });
        }
        // Komentari baris ini untuk debugging
        // fs.unlinkSync(pdfFilePath);
      });
    }, 1000);
  } catch (error) {
    res.status(500).json({ message: 'Error processing request', error: error.message });
  }
};

module.exports = { createAudit, getAllAudit, generateAuditPDF };