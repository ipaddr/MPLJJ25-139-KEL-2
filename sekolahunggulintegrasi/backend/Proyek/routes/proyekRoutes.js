// routes/proyekRoutes.js
const express = require('express');
const router = express.Router();
const {
  getAllProyek,
  createProyek,
  updateProyekProgress,
  markProyekAsCompleted,
  generateProyekPDF,
} = require('../controllers/proyekController');

router.get('/proyek', getAllProyek);
router.post('/proyek', createProyek);
router.put('/proyek/:id', updateProyekProgress);
router.put('/proyek/:id/selesai', markProyekAsCompleted);
router.get('/:id/pdf', generateProyekPDF);

module.exports = router;