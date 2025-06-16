// controllers/proposalController.js
const Proposal = require('../models/Proposal');

const submitProposal = async (req, res) => {
  try {
    const {
      jenisProposal,
      judulProposal,
      namaSekolah,
      alamatSekolah,
      jumlahSiswa,
      fasilitas
    } = req.body;

    const { dokumenProposal, desainRencana, dokumenRAB } = req.files || {};

    if (
      !jenisProposal ||
      !judulProposal ||
      !namaSekolah ||
      !alamatSekolah ||
      !jumlahSiswa ||
      !fasilitas ||
      !dokumenProposal || !desainRencana || !dokumenRAB
    ) {
      return res.status(400).json({ message: 'Semua field harus diisi.' });
    }

    if (isNaN(jumlahSiswa)) {
      return res.status(400).json({ message: 'Jumlah siswa harus berupa angka.' });
    }

    const proposal = new Proposal({
      jenisProposal,
      judulProposal,
      namaSekolah,
      alamatSekolah,
      jumlahSiswa: parseInt(jumlahSiswa),
      fasilitas,
      dokumenProposalPath: dokumenProposal[0].path,
      desainRencanaPath: desainRencana[0].path,
      dokumenRABPath: dokumenRAB[0].path,
    });

    await proposal.save();

    res.status(201).json({
      message: 'Proposal berhasil diajukan!',
      proposal
    });
  } catch (error) {
    console.error('Error submitting proposal:', error);
    res.status(500).json({ message: 'Terjadi kesalahan saat mengajukan proposal.' });
  }
};

// controllers/proposalController.js
const getProposals = async (req, res) => {
  try {
    const proposals = await Proposal.find({ status: 'Menunggu' }).sort({ createdAt: -1 });
    console.log('Proposals fetched:', proposals); // Debugging
    res.status(200).json(proposals);
  } catch (error) {
    console.error('Error fetching proposals:', error.message, error.stack);
    res.status(500).json({ message: 'Terjadi kesalahan saat mengambil data proposal.', error: error.message });
  }
};

const updateProposalStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const proposal = await Proposal.findById(id);
    if (!proposal) {
      return res.status(404).json({ message: 'Proposal tidak ditemukan.' });
    }

    proposal.status = status;
    await proposal.save();

    res.status(200).json({ message: 'Status proposal berhasil diperbarui.', proposal });
  } catch (error) {
    console.error('Error updating proposal status:', error);
    res.status(500).json({ message: 'Terjadi kesalahan saat memperbarui status.' });
  }
};
// controllers/proposalController.js

const getAllProposals = async (req, res) => {
  try {
    const proposals = await Proposal.find().sort({ createdAt: -1 });
    console.log('All Proposals fetched:', proposals); // Debugging
    res.status(200).json(proposals);
  } catch (error) {
    console.error('Error fetching all proposals:', error.message, error.stack);
    res.status(500).json({ message: 'Terjadi kesalahan saat mengambil semua data proposal.', error: error.message });
  }
};
module.exports = { submitProposal, getProposals, getAllProposals, updateProposalStatus };