
const express = require('express');
const router = express.Router();
const { submitProposal, getProposals, getAllProposals, updateProposalStatus } = require('../controllers/proposalController');
const multer = require('multer');

const upload = multer({ dest: 'uploads/' });

router.post(
  '/proposals/submit',
  upload.fields([
    { name: 'dokumenProposal', maxCount: 1 },
    { name: 'desainRencana', maxCount: 1 },
    { name: 'dokumenRAB', maxCount: 1 },
  ]),
  submitProposal
);

router.get('/proposals', getProposals);
router.patch('/proposal/:id/status', updateProposalStatus);
router.get('/all-proposals', getAllProposals);
module.exports = router;