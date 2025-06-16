const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { auth, authorizeAdmin } = require('../../middleware/auth');

router.get('/', auth, authorizeAdmin, userController.getAllUsers);
router.post('/', auth, authorizeAdmin, userController.createUser);
router.put('/:id', auth, authorizeAdmin, userController.updateUser);
router.delete('/:id', auth, authorizeAdmin, userController.deleteUser);

router.post('/login', userController.loginUser);
router.get('/profile', auth, userController.getProfile); // Pastikan auth diaktifkan
router.put('/update-profile', auth, userController.updateProfile); // Tambah endpoint baru



module.exports = router;