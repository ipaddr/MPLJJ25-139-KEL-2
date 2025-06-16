const express = require('express');
const router = express.Router();
const sekolahController = require('../controllers/sekolahController');
const upload= require('../../middleware/uploadMiddleware');


// Route input data sekolah
router.post('/', upload.array('dokumentasi', 5), sekolahController.createSekolah);

// Optional: untuk testing
router.get('/', sekolahController.getAllSekolah);

// Endpoint PUT verifikasi
router.put('/:id/verifikasi', sekolahController.verifikasiSekolah);

module.exports = router;
