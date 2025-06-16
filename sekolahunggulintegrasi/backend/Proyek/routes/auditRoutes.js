// routes/auditRoutes.js
const express = require('express');
const router = express.Router();
const { createAudit, getAllAudit, generateAuditPDF } = require('../controllers/auditController');

router.post('/audit', createAudit);
router.get('/audit', getAllAudit);
router.get('/audit/:id/pdf', generateAuditPDF); // Endpoint baru untuk PDF

module.exports = router;