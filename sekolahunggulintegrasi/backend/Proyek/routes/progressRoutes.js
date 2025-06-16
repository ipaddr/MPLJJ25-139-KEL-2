// routes/progressRoutes.js
const express = require('express');
const router = express.Router();
const multer = require('multer');
const { createProgress, getAllProgress } = require('../controllers/progressController');

// Konfigurasi multer untuk upload file
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const ext = file.originalname.split('.').pop();
    cb(null, `${Date.now()}-${file.originalname.replace(`.${ext}`, '')}.${ext}`);
  },
});

const upload = multer({ storage });

router.post('/progress', upload.single('foto'), createProgress);
router.get('/progress', getAllProgress);

module.exports = router;