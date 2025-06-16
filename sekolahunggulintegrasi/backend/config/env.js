// Memuat variabel dari file .env
require('dotenv').config();

// Mengekspor variabel-variabel yang dibutuhkan
module.exports = {
  PORT: process.env.PORT || 3000,
  MONGODB_URI: process.env.MONGODB_URI,
  MONGO_COLLECTION: process.env.MONGO_COLLECTION,
  jwtSecret: process.env.JWT_SECRET, 
};
