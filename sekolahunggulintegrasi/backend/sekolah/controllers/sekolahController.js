const Sekolah = require('../models/sekolah');

// POST data sekolah
exports.createSekolah = async (req, res) => {
  try {
    const { nama, npsn, alamat, jenjang, jumlahSiswa, fasilitas } = req.body;
    const dokumentasi = req.files?.map(file => file.path.replace(/\\/g, '/')) || [];

    // Parsing fasilitas
    let fasilitasArray;
    if (typeof fasilitas === 'string') {
      try {
        fasilitasArray = JSON.parse(fasilitas);
        if (!Array.isArray(fasilitasArray)) {
          throw new Error('Fasilitas harus berupa array');
        }
      } catch (err) {
        return res.status(400).json({ error: 'Format fasilitas tidak valid. Harus berupa array JSON.' });
      }
    } else if (Array.isArray(fasilitas)) {
      fasilitasArray = fasilitas;
    } else {
      fasilitasArray = [];
    }

    const sekolahBaru = new Sekolah({
      nama,
      npsn,
      alamat,
      jenjang,
      jumlahSiswa: parseInt(jumlahSiswa), // Pastikan jumlahSiswa diubah ke number
      fasilitas: fasilitasArray,
      dokumentasi,
      statusVerifikasi: 'menunggu_verifikasi',
    });

    await sekolahBaru.save();
    res.status(201).json({ message: 'Data sekolah berhasil dikirim dan menunggu verifikasi Dinas.', data: sekolahBaru });
  } catch (err) {
    console.error(err); // Tambahkan log untuk debug
    res.status(500).json({ error: err.message });
  }
};

// GET semua lcd
exports.getAllSekolah = async (req, res) => {
  try {
    const sekolahList = await Sekolah.find();
    res.status(200).json(sekolahList);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
};

// PUT verifikasi sekolah oleh Dinas
exports.verifikasiSekolah = async (req, res) => {
  try {
    const { id } = req.params;
    const { statusVerifikasi, catatan } = req.body;

    if (!['disetujui', 'ditolak'].includes(statusVerifikasi)) {
      return res.status(400).json({ error: 'Status verifikasi tidak valid. Gunakan "disetujui" atau "ditolak".' });
    }

    const sekolah = await Sekolah.findById(id);
    if (!sekolah) {
      return res.status(404).json({ error: 'Data sekolah tidak ditemukan.' });
    }

    sekolah.statusVerifikasi = statusVerifikasi;
    sekolah.catatan = catatan || '';

    await sekolah.save();
    res.status(200).json({ message: `Status verifikasi berhasil diubah menjadi ${statusVerifikasi}.`, data: sekolah });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
};
// GET semua data sekolah
exports.getAllSekolah = async (req, res) => {
  try {
    const { status } = req.query;
    let filter = {};
    if (status === 'verified') {
      filter.statusVerifikasi = { $in: ['disetujui', 'ditolak'] }; // Hanya ambil disetujui atau ditolak
    } else if (status) {
      filter.statusVerifikasi = status; // Filter berdasarkan status tertentu
    }
    const sekolahList = await Sekolah.find(filter);
    res.status(200).json(sekolahList);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
};