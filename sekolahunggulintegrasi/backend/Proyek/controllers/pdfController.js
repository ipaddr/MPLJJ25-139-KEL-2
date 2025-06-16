const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

const generatePDF = async (req, res) => {
  try {
    const { type, data } = req.body;

    if (!type || !data) {
      return res.status(400).json({ message: 'Type dan data wajib diisi.' });
    }

    const tempDir = path.join(__dirname, '../temp');
    if (!fs.existsSync(tempDir)) fs.mkdirSync(tempDir);
    const pdfFilePath = path.join(tempDir, `${type}_${Date.now()}.pdf`);

    const doc = new PDFDocument({ margin: 50 });
    doc.pipe(fs.createWriteStream(pdfFilePath));

    // Tambahkan judul
    doc.fontSize(16).text(`Laporan ${type}`, { align: 'center' });
    doc.moveDown();

    // Definisikan tabel berdasarkan tipe
    let table = { headers: ['Kategori', 'Detail'], rows: [] };
    switch (type.toLowerCase()) {
      case 'proposal':
        table.rows = [
          ['Jenis Proposal', data.jenisProposal || 'N/A'],
          ['Judul Proposal', data.judulProposal || 'N/A'],
          ['Nama Sekolah', data.namaSekolah || 'N/A'],
          ['Alamat Sekolah', data.alamatSekolah || 'N/A'],
          ['Jumlah Siswa', data.jumlahSiswa?.toString() || 'N/A'],
          ['Fasilitas', data.fasilitas || 'N/A'],
          ['Status', data.status || 'N/A'],
        ];
        break;
      case 'proyek':
        table.rows = [
          ['Nama Sekolah', data.namaSekolah || 'N/A'],
          ['Lokasi', data.lokasi || 'N/A'],
          ['Jadwal', data.jadwal || 'N/A'],
          ['Status', data.status || 'N/A'],
          ['Progress Fisik', `${(data.progressFisik * 100).toFixed(2)}%` || 'N/A'],
          ['Progress Keuangan', `${(data.progressKeuangan * 100).toFixed(2)}%` || 'N/A'],
        ];
        break;
      case 'progress':
        table.rows = [
          ['Minggu', data.minggu?.toString() || 'N/A'],
          ['Fisik', `${(data.fisik * 100).toFixed(2)}%` || 'N/A'],
          ['Keuangan', `${(data.keuangan * 100).toFixed(2)}%` || 'N/A'],
          ['Catatan', data.catatan || 'N/A'],
        ];
        break;
      case 'audit':
        table.rows = [
          ['Nama Proyek', data.namaProyek || 'N/A'],
          ['Dana Awal', `Rp ${data.danaAwal?.toLocaleString('id-ID')}` || 'N/A'],
          ['Pengeluaran Minggu Ini', `Rp ${data.pengeluaranMingguIni?.toLocaleString('id-ID')}` || 'N/A'],
          ['Total Pengeluaran', `Rp ${data.totalPengeluaran?.toLocaleString('id-ID')}` || 'N/A'],
          ['Total RAB', `Rp ${data.totalRab?.toLocaleString('id-ID')}` || 'N/A'],
          ['Catatan Auditor', data.catatanAuditor || 'Tidak ada catatan'],
        ];
        break;
      default:
        return res.status(400).json({ message: 'Tipe dokumen tidak didukung.' });
    }

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
  res.setHeader('Content-Disposition', `attachment; filename="${type}_${Date.now()}.pdf"`);
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

module.exports = { generatePDF };