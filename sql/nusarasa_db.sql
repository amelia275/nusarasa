-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 27 Nov 2025 pada 02.36
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nusarasa_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) NOT NULL,
  `session_id` varchar(128) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `note` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'Mains'),
(2, 'Sides'),
(3, 'Drinks'),
(4, 'Dessert');

-- --------------------------------------------------------

--
-- Struktur dari tabel `chefs`
--

CREATE TABLE `chefs` (
  `chef_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `experience` int(11) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `active_status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `inventory`
--

CREATE TABLE `inventory` (
  `inventory_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `quantity` int(11) DEFAULT 0,
  `unit_purchase` enum('kg','pcs') DEFAULT 'kg',
  `ml_per_pcs` int(11) DEFAULT NULL,
  `gram_per_pcs` int(11) DEFAULT NULL,
  `pieces_per_pcs` int(11) DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `inventory`
--

INSERT INTO `inventory` (`inventory_id`, `item_name`, `quantity`, `unit_purchase`, `ml_per_pcs`, `gram_per_pcs`, `pieces_per_pcs`, `last_updated`) VALUES
(1, 'Daging Sapi', 0, 'kg', NULL, NULL, NULL, '2025-11-14 14:48:28'),
(2, 'Daging Kambing', 0, 'kg', NULL, NULL, NULL, '2025-11-14 14:48:28'),
(3, 'Daging Ayam', 0, 'kg', NULL, NULL, NULL, '2025-11-14 14:48:28'),
(4, 'Daging Bebek', 0, 'kg', NULL, NULL, NULL, '2025-11-14 14:48:28'),
(5, 'Ikan Laut', 0, 'kg', NULL, NULL, NULL, '2025-11-14 14:48:28'),
(6, 'Cingur Sapi', 0, 'pcs', NULL, 250, NULL, '2025-11-14 14:48:28'),
(7, 'Ikan Tenggiri Giling', 0, 'pcs', NULL, 500, NULL, '2025-11-14 14:48:28'),
(8, 'Beras', 0, 'kg', NULL, NULL, NULL, '2025-11-14 14:48:28'),
(9, 'Ketupat Instan', 0, 'pcs', NULL, 180, NULL, '2025-11-14 14:48:28'),
(10, 'Tepung Beras', 0, 'pcs', NULL, 500, NULL, '2025-11-14 14:48:28'),
(11, 'Tepung Terigu', 0, 'pcs', NULL, 1000, NULL, '2025-11-14 14:55:22'),
(12, 'Tepung Tapioka', 0, 'pcs', NULL, 500, NULL, '2025-11-14 14:55:22'),
(13, 'Bihun Kering', 0, 'pcs', NULL, 250, NULL, '2025-11-14 14:55:22'),
(14, 'Santan Kental', 0, 'pcs', 200, NULL, NULL, '2025-11-14 14:55:22'),
(15, 'Santan Cair', 0, 'pcs', 1000, NULL, NULL, '2025-11-14 14:55:22'),
(16, 'Susu Kental Manis', 0, 'pcs', 375, NULL, NULL, '2025-11-14 14:55:22'),
(17, 'Susu Cair Full Cream', 0, 'pcs', 1000, NULL, NULL, '2025-11-14 14:55:22'),
(18, 'Air Kelapa Muda', 0, 'pcs', 1000, NULL, NULL, '2025-11-14 14:55:22'),
(19, 'Bawang Putih', 0, 'pcs', NULL, 100, NULL, '2025-11-14 14:55:22'),
(20, 'Bawang Merah', 0, 'pcs', NULL, 100, NULL, '2025-11-14 14:55:22'),
(21, 'Jahe', 0, 'pcs', NULL, 100, NULL, '2025-11-14 14:55:22'),
(22, 'Lengkuas', 0, 'pcs', NULL, 150, NULL, '2025-11-14 14:55:22'),
(23, 'Kunyit', 0, 'pcs', NULL, 100, NULL, '2025-11-14 14:55:22'),
(24, 'Serai', 0, 'pcs', NULL, 50, NULL, '2025-11-14 14:55:22'),
(25, 'Daun Jeruk', 0, 'pcs', NULL, 5, NULL, '2025-11-14 14:55:22'),
(26, 'Daun Salam', 0, 'pcs', NULL, 5, NULL, '2025-11-14 14:55:22'),
(27, 'Daun Pandan', 0, 'pcs', NULL, 5, NULL, '2025-11-14 14:55:22'),
(28, 'Kemiri', 0, 'pcs', NULL, 20, NULL, '2025-11-14 14:55:22'),
(29, 'Kluwek', 0, 'pcs', NULL, 20, NULL, '2025-11-14 14:55:22'),
(30, 'Cabe Rawit', 0, 'pcs', NULL, 50, NULL, '2025-11-14 14:59:56'),
(31, 'Cabe Merah Besar', 0, 'pcs', NULL, 100, NULL, '2025-11-14 15:01:27'),
(32, 'Ketumbar Bubuk', 0, 'pcs', NULL, 50, NULL, '2025-11-14 14:59:56'),
(33, 'Lada Bubuk', 0, 'pcs', NULL, 50, NULL, '2025-11-14 14:59:56'),
(34, 'Jinten', 0, 'pcs', NULL, 20, NULL, '2025-11-14 14:59:56'),
(35, 'Kunyit Bubuk', 0, 'pcs', NULL, 50, NULL, '2025-11-14 14:59:56'),
(36, 'Kencur', 0, 'pcs', NULL, 100, NULL, '2025-11-14 14:59:56'),
(37, 'Kapulaga', 0, 'pcs', NULL, 20, NULL, '2025-11-14 14:59:56'),
(38, 'Garam', 0, 'pcs', NULL, 1000, NULL, '2025-11-14 14:59:56'),
(39, 'Penyedap Rasa', 0, 'pcs', NULL, 250, NULL, '2025-11-14 14:59:56'),
(40, 'Gula Pasir', 0, 'pcs', NULL, 1000, NULL, '2025-11-14 14:59:56'),
(41, 'Gula Aren', 0, 'pcs', NULL, 500, NULL, '2025-11-14 14:59:56'),
(42, 'Kecap Manis', 0, 'pcs', 500, NULL, NULL, '2025-11-14 14:59:56'),
(43, 'Saus Sambal', 0, 'pcs', 500, NULL, NULL, '2025-11-14 14:59:56'),
(44, 'Minyak Goreng', 0, 'pcs', 2000, NULL, NULL, '2025-11-14 14:59:56'),
(45, 'Sawi Hijau', 0, 'pcs', NULL, 250, NULL, '2025-11-14 14:59:56'),
(46, 'Kol', 0, 'pcs', NULL, 500, NULL, '2025-11-14 14:59:56'),
(47, 'Timun', 0, 'pcs', NULL, 250, NULL, '2025-11-14 14:59:56'),
(48, 'Tomat', 0, 'pcs', NULL, 200, NULL, '2025-11-14 14:59:56'),
(49, 'Kangkung', 0, 'pcs', NULL, 250, NULL, '2025-11-14 15:03:49'),
(50, 'Bawang Daun', 0, 'pcs', NULL, 100, NULL, '2025-11-14 15:03:49'),
(51, 'Pisang Raja', 0, 'pcs', NULL, 120, NULL, '2025-11-14 15:03:49'),
(52, 'Melon', 0, 'pcs', NULL, 1000, NULL, '2025-11-14 15:03:49'),
(53, 'Nangka', 0, 'pcs', NULL, 500, NULL, '2025-11-14 15:03:49'),
(54, 'Alpukat', 50, 'pcs', NULL, 300, NULL, '2025-11-23 07:06:10'),
(55, 'Kelapa Muda', 0, 'pcs', NULL, NULL, 1, '2025-11-14 15:03:49'),
(56, 'Teh Hitam Bubuk', 0, 'pcs', NULL, 100, NULL, '2025-11-14 15:03:49'),
(57, 'Kopi Bubuk Arabica', 0, 'pcs', NULL, 200, NULL, '2025-11-14 15:03:49'),
(58, 'Sirup Merah Cocopandan', 0, 'pcs', 650, NULL, NULL, '2025-11-14 15:03:49'),
(59, 'Gula Cair', 0, 'pcs', 1000, NULL, NULL, '2025-11-14 15:05:30'),
(60, 'Biji Selasih', 0, 'pcs', NULL, 50, NULL, '2025-11-14 15:05:30'),
(61, 'Tepung Hunkwe', 0, 'pcs', NULL, 250, NULL, '2025-11-14 15:05:30'),
(62, 'Daun Pisang', 0, 'pcs', NULL, NULL, 1, '2025-11-14 15:05:30'),
(63, 'Santan Bubuk', 0, 'pcs', NULL, 50, NULL, '2025-11-14 15:05:30'),
(64, 'Tepung Sagu', 0, 'pcs', NULL, 500, NULL, '2025-11-14 15:05:30'),
(65, 'Pewarna Hijau Pandan', 0, 'pcs', 30, NULL, NULL, '2025-11-14 15:05:30'),
(66, 'Koya Bubuk', 0, 'pcs', NULL, 500, NULL, '2025-11-14 15:20:55'),
(67, 'Terasi', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:26:38'),
(68, 'Telur', 0, 'kg', NULL, NULL, 16, '2025-11-14 15:28:22'),
(69, 'Kayu Manis', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:38:06'),
(70, 'Cengkeh', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:38:06'),
(71, 'Tauge', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:40:29'),
(72, 'Petis Udang', 0, 'pcs', NULL, 250, NULL, '2025-11-14 15:40:29'),
(73, 'Kacang Tanah Goreng', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:41:16'),
(74, 'Gula Merah', 0, 'pcs', NULL, 500, NULL, '2025-11-14 15:52:33'),
(75, 'Air Mineral', 0, 'pcs', 19000, NULL, NULL, '2025-11-14 15:53:36'),
(76, 'Es Batu', 0, 'pcs', NULL, 5000, NULL, '2025-11-14 15:52:33'),
(77, 'Jelly', 0, 'pcs', NULL, 500, NULL, '2025-11-14 15:52:33'),
(78, 'Biji Selasih', 0, 'pcs', NULL, 200, NULL, '2025-11-14 15:52:33'),
(79, 'Kulit Pastel', 0, 'pcs', NULL, NULL, 100, '2025-11-14 15:52:33'),
(80, 'Wortel', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:52:33'),
(81, 'Durian', 0, 'kg', NULL, NULL, NULL, '2025-11-14 15:52:33'),
(82, 'Tempe', 0, 'pcs', NULL, NULL, 1, '2025-11-14 16:21:32'),
(83, 'Tahu', 0, 'pcs', NULL, NULL, 1, '2025-11-14 16:21:32');

-- --------------------------------------------------------

--
-- Struktur dari tabel `menu_items`
--

CREATE TABLE `menu_items` (
  `menu_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` enum('available','unavailable') DEFAULT 'available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `menu_items`
--

INSERT INTO `menu_items` (`menu_id`, `name`, `category_id`, `description`, `price`, `image`, `status`) VALUES
(1, 'Rawon Daging', 1, 'Sup daging sapi khas Jawa Timur dengan kuah hitam gurih dari kluwek.', 55000.00, 'rawon.jpg', 'available'),
(2, 'Soto Madura', 1, 'Kuah bening gurih dengan potongan daging sapi, koya, dan sambal khas Madura.', 48000.00, 'soto.jpg', 'available'),
(3, 'Tempe Goreng', 2, 'Tempe goreng renyah dengan bumbu ketumbar dan bawang putih pilihan.', 15000.00, 'tempe.jpg', 'available'),
(4, 'Es Teh Manis', 3, 'Teh hitam dingin dengan aroma melati yang menenangkan.', 10000.00, 'teh.jpg', 'available'),
(5, 'Coto Makassar', 1, 'Sup daging sapi kental dengan rempah khas Makassar dan ketupat lembut.', 52000.00, 'coto.jpg', 'available'),
(6, 'Es Pisang Ijo', 4, 'Pisang dibalut adonan hijau lembut, disajikan dengan sirup merah dan es serut segar.', 28000.00, 'pisjo.jpg', 'available'),
(7, 'Ayam Taliwang', 1, 'Ayam bakar khas lombok dengan bumbu pedas dan gurih.', 89000.00, 'taliwang.jpg', 'available'),
(8, 'Nasi Goreng Kampung', 1, 'Nasi goreng dengan menggunakan bahan sederhana sehingga mengeluarkan cita rasa kampoeng.', 40000.00, 'nasgor.jpg', 'available'),
(9, 'Tempe Mendoan', 2, 'Tempe yang dipotong tipis dan digoreng setengah matang dengan dibaluri tepung.', 25000.00, 'mendoan.png', 'available'),
(10, 'Tahu Tempe Bacem', 2, 'Tahu dan tempe yang diolah melalui proses perendaman dengan bumbu manis dan gurih.', 30000.00, 'tahu tempe bacem.jpg', 'available'),
(11, 'Rendang', 1, 'Hidangan daging sapi khas Sumatra Barat yang dimasak lama hingga dagingnya empuk dan bumbunya meresap.', 100000.00, 'rendang.jpg', 'available'),
(12, 'Es Campur', 4, 'Hidangan penutup manis dan menyegarkan, terbuat dari es serut yang dicampur berbagai isian, lalu disiram sirup dan susu kental manis.', 20000.00, 'es campur.jpeg', 'available'),
(13, 'Bebek Bumbu Hitam', 1, 'Hidangan bebek dari madura yang memakai bumbu hitam khas madura.', 90000.00, 'bebek hitam.jpeg', 'available'),
(14, 'Sate Kambing', 1, 'Daging kambing yang ditusuk dan dibakar diatas arang sehingga memiliki rasa smoky.', 40000.00, 'Satekambing.jpeg', 'available'),
(15, 'Ikan Bakar Manokwari', 1, 'Ikan bakar khas papua yang memiliki cita rasa segar karena memakai sambal mentah.', 55000.00, 'ikanmanokwari.jpg', 'available'),
(16, 'Soto Banjar', 1, 'Soto khas banjar yang memiliki rasa agak ringan dan tidak terlalu bold.', 35000.00, 'sotobanjar.jpg', 'available'),
(17, 'Pempek', 2, 'Makanan khas palembang yang memakai ikan giling didalam adonannya.', 25000.00, 'pempek.jpg', 'available'),
(18, 'Rujak Cingur', 1, 'Makanan khas Surabaya yang menggunakan irisan cingur (moncong atau mulut sapi) yang direbus.', 39000.00, 'rujakcingur.jpg', 'available'),
(19, 'Gudeg', 1, 'Masakan khas Yogyakarta dari nangka muda yang dimasak dengan santan, gula merah, dan rempah-rempah hingga lembut dengan rasa manis gurih.', 50000.00, 'gudeg.jpeg', 'available'),
(20, 'Ayam Betutu', 1, 'Ayam betutu khas Bali, dibumbui rempah dan dimasak perlahan dalam daun pisang hingga empuk.', 89000.00, 'ayambetutu.jpeg', 'available'),
(21, 'Es Teler', 3, 'Kombinasi potongan alpukat, kelapa muda, nangka, dan susu kental manis dalam sajian es serut yang lezat dan menyegarkan.', 20000.00, 'es teler-3.jpeg', 'available'),
(22, 'Teh Talua', 3, 'Minuman khas Minang yang unik, terbuat dari campuran teh panas, kuning telur, dan sedikit gula.', 18000.00, 'tehtalua.jpeg', 'available'),
(23, 'Es Cendol', 3, 'Minuman manis menyegarkan berisi cendol hijau dari tepung beras, santan gurih, dan gula aren cair.', 23000.00, 'cendol.jpeg', 'available'),
(24, 'Es Kelapa Muda', 3, 'Segarnya air kelapa muda alami dengan daging kelapa lembut.', 15000.00, 'es kelapa.jpeg', 'available'),
(25, 'Kopi Hitam', 3, 'Kopi hitam klasik dengan cita rasa murni dan aroma kuat, dibuat dari espresso yang diseduh dengan air panas.', 18000.00, 'kopi americano.jpeg', 'available'),
(26, 'Saraba', 3, 'Minuman tradisional khas Makassar berbahan dasar jahe, gula aren, dan santan.', 21000.00, 'saraba.jpeg', 'available'),
(27, 'Es Kuwut', 3, 'Minuman khas Bali yang menyegarkan, terbuat dari campuran air kelapa, melon, biji selasih, dan perasan jeruk nipis.', 13000.00, 'es kuwut.jpeg', 'available'),
(28, 'Teh Tarik', 3, 'Terbuat dari campuran teh hitam dan susu kental manis yang “ditarik” berulang kali hingga menghasilkan buih lembut di permukaannya.', 15000.00, 'teh tarik-2.jpeg', 'available'),
(29, 'Barongko', 4, 'Kue khas Bugis yang lembut dan manis, terbuat dari pisang yang dikukus bersama telur, santan, dan gula dalam bungkus daun pisang.', 25000.00, 'barongko.jpeg', 'available'),
(30, 'Jalangkote', 4, 'Camilan khas Makassar mirip pastel, berisi tumisan sayuran, bihun, dan telur rebus.', 15000.00, 'jalangkote.jpeg', 'available'),
(31, 'Klappertaart', 4, 'Dessert khas Manado bercita rasa Belanda, dibuat dari campuran kelapa muda, susu, mentega, dan telur.', 18000.00, 'Klappertaart.jpeg', 'available'),
(32, 'Pancake Durian', 4, 'Olahan lembut berisi daging durian asli dan krim manis, dibalut kulit pancake tipis.', 35000.00, 'pancakedurian.jpeg', 'available'),
(33, 'Kue Talam', 4, 'Kue tradisional dua lapis dengan tekstur lembut dan rasa manis gurih.', 25000.00, 'kue talam.jpeg', 'available'),
(34, 'Putu Mayang', 4, 'Kue cantik berbentuk untaian mi dari tepung beras, disajikan dengan kuah gula merah dan santan.', 18000.00, 'putu mayang.jpeg', 'available'),
(35, 'Surabi', 4, 'Kue tradisional berbahan dasar tepung beras dan santan, dimasak di atas tungku tanah liat.', 25000.00, 'surabi.jpeg', 'available'),
(36, 'Kue Jorong', 4, 'Kue khas Minangkabau berlapis hijau dan putih, terbuat dari campuran tepung beras, santan, dan daun pandan.', 10000.00, 'kue jorong.jpeg', 'available');

-- --------------------------------------------------------

--
-- Struktur dari tabel `menu_recipes`
--

CREATE TABLE `menu_recipes` (
  `recipes_id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `unit` enum('gram','ml','pcs') NOT NULL DEFAULT 'gram'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `menu_recipes`
--

INSERT INTO `menu_recipes` (`recipes_id`, `menu_id`, `inventory_id`, `amount`, `unit`) VALUES
(1, 1, 1, 150, 'gram'),
(2, 1, 20, 20, 'gram'),
(3, 1, 19, 10, 'gram'),
(4, 1, 29, 20, 'gram'),
(5, 1, 24, 1, 'pcs'),
(6, 1, 26, 1, 'pcs'),
(7, 1, 38, 3, 'gram'),
(8, 1, 40, 2, 'gram'),
(9, 1, 44, 10, 'ml'),
(10, 2, 1, 120, 'gram'),
(11, 2, 19, 8, 'gram'),
(12, 2, 20, 10, 'gram'),
(13, 2, 24, 1, 'pcs'),
(14, 2, 25, 1, 'pcs'),
(15, 2, 38, 3, 'gram'),
(16, 2, 44, 10, 'ml'),
(17, 2, 66, 5, 'gram'),
(18, 5, 1, 150, 'gram'),
(19, 5, 20, 15, 'gram'),
(20, 5, 19, 10, 'gram'),
(21, 5, 32, 2, 'gram'),
(22, 5, 31, 5, 'gram'),
(23, 5, 38, 3, 'gram'),
(24, 5, 44, 10, 'ml'),
(25, 7, 3, 200, 'gram'),
(26, 7, 30, 15, 'gram'),
(27, 7, 19, 10, 'gram'),
(28, 7, 38, 3, 'gram'),
(29, 7, 40, 2, 'gram'),
(30, 7, 44, 10, 'ml'),
(31, 7, 67, 3, 'gram'),
(32, 8, 8, 200, 'gram'),
(33, 8, 68, 1, 'pcs'),
(34, 8, 19, 8, 'gram'),
(35, 8, 20, 10, 'gram'),
(36, 8, 42, 10, 'ml'),
(37, 8, 38, 2, 'gram'),
(38, 8, 44, 10, 'ml'),
(39, 11, 1, 150, 'gram'),
(40, 11, 15, 100, 'ml'),
(41, 11, 20, 20, 'gram'),
(42, 11, 19, 10, 'gram'),
(43, 11, 30, 15, 'gram'),
(44, 11, 22, 5, 'gram'),
(45, 11, 25, 1, 'pcs'),
(46, 11, 38, 3, 'gram'),
(47, 13, 4, 180, 'gram'),
(48, 13, 20, 20, 'gram'),
(49, 13, 19, 10, 'gram'),
(50, 13, 30, 10, 'gram'),
(51, 13, 42, 15, 'ml'),
(52, 13, 38, 3, 'gram'),
(53, 14, 2, 120, 'gram'),
(54, 14, 42, 10, 'ml'),
(55, 14, 20, 10, 'gram'),
(56, 14, 30, 5, 'gram'),
(57, 14, 38, 2, 'gram'),
(58, 15, 5, 180, 'gram'),
(59, 15, 31, 15, 'gram'),
(60, 15, 19, 10, 'gram'),
(61, 15, 48, 20, 'gram'),
(62, 15, 38, 3, 'gram'),
(63, 16, 3, 120, 'gram'),
(64, 16, 19, 10, 'gram'),
(65, 16, 20, 15, 'gram'),
(66, 16, 38, 3, 'gram'),
(67, 16, 70, 1, 'gram'),
(68, 16, 69, 1, 'gram'),
(69, 18, 6, 120, 'gram'),
(70, 18, 49, 50, 'gram'),
(71, 18, 71, 40, 'gram'),
(72, 18, 72, 20, 'gram'),
(73, 18, 73, 10, 'gram'),
(74, 18, 41, 5, 'gram'),
(75, 19, 53, 150, 'gram'),
(76, 19, 14, 100, 'gram'),
(77, 19, 26, 1, 'pcs'),
(78, 19, 38, 3, 'gram'),
(79, 19, 74, 10, 'gram'),
(80, 20, 3, 180, 'gram'),
(81, 20, 20, 20, 'gram'),
(82, 20, 19, 10, 'gram'),
(83, 20, 31, 15, 'gram'),
(84, 20, 36, 5, 'gram'),
(85, 20, 38, 3, 'gram'),
(86, 17, 7, 80, 'gram'),
(87, 17, 12, 40, 'gram'),
(88, 17, 19, 5, 'gram'),
(89, 17, 38, 3, 'gram'),
(94, 4, 56, 3, 'gram'),
(95, 4, 40, 10, 'gram'),
(96, 4, 75, 150, 'ml'),
(97, 4, 76, 80, 'gram'),
(98, 21, 54, 40, 'gram'),
(99, 21, 55, 40, 'gram'),
(100, 21, 53, 20, 'gram'),
(101, 21, 16, 15, 'ml'),
(102, 21, 76, 100, 'gram'),
(103, 22, 56, 3, 'gram'),
(104, 22, 68, 1, 'pcs'),
(105, 22, 40, 10, 'gram'),
(106, 22, 75, 150, 'ml'),
(107, 23, 77, 60, 'gram'),
(108, 23, 15, 50, 'ml'),
(109, 23, 59, 20, 'ml'),
(110, 23, 76, 100, 'gram'),
(111, 24, 18, 200, 'ml'),
(112, 24, 55, 40, 'gram'),
(113, 24, 40, 10, 'gram'),
(114, 24, 76, 80, 'gram'),
(115, 25, 57, 10, 'gram'),
(116, 25, 75, 150, 'ml'),
(121, 26, 21, 20, 'gram'),
(122, 26, 41, 15, 'gram'),
(123, 26, 15, 50, 'ml'),
(124, 26, 75, 100, 'ml'),
(125, 27, 18, 150, 'ml'),
(126, 27, 52, 40, 'gram'),
(127, 27, 60, 5, 'gram'),
(128, 27, 76, 80, 'gram'),
(129, 28, 56, 3, 'gram'),
(130, 28, 16, 20, 'ml'),
(131, 28, 75, 150, 'ml'),
(132, 6, 51, 1, 'pcs'),
(133, 6, 10, 20, 'gram'),
(134, 6, 58, 15, 'ml'),
(135, 6, 76, 100, 'gram'),
(136, 12, 54, 20, 'gram'),
(137, 12, 81, 20, 'gram'),
(138, 12, 77, 10, 'gram'),
(139, 12, 52, 20, 'gram'),
(140, 12, 53, 20, 'gram'),
(141, 12, 58, 15, 'ml'),
(142, 12, 17, 15, 'ml'),
(143, 12, 76, 100, 'gram'),
(144, 29, 51, 80, 'gram'),
(145, 29, 68, 1, 'pcs'),
(146, 29, 15, 50, 'ml'),
(147, 29, 40, 10, 'gram'),
(148, 30, 79, 5, 'pcs'),
(149, 30, 13, 100, 'gram'),
(150, 30, 80, 100, 'gram'),
(151, 30, 68, 5, 'pcs'),
(152, 30, 38, 10, 'gram'),
(153, 31, 55, 40, 'gram'),
(154, 31, 17, 60, 'ml'),
(155, 31, 68, 1, 'pcs'),
(156, 31, 40, 10, 'gram'),
(157, 32, 81, 40, 'gram'),
(158, 32, 17, 20, 'ml'),
(159, 32, 11, 15, 'gram'),
(160, 33, 10, 20, 'gram'),
(161, 33, 14, 40, 'ml'),
(162, 33, 40, 10, 'gram'),
(163, 34, 10, 25, 'gram'),
(164, 34, 14, 40, 'ml'),
(165, 34, 74, 10, 'gram'),
(166, 35, 10, 30, 'gram'),
(167, 35, 14, 50, 'ml'),
(168, 35, 40, 10, 'gram'),
(169, 36, 10, 20, 'gram'),
(170, 36, 15, 40, 'ml'),
(171, 36, 40, 10, 'gram'),
(172, 3, 82, 1, 'pcs'),
(173, 3, 19, 3, 'gram'),
(174, 3, 32, 1, 'gram'),
(175, 3, 38, 2, 'gram'),
(176, 3, 44, 10, 'ml'),
(182, 9, 82, 1, 'pcs'),
(183, 9, 11, 20, 'gram'),
(184, 9, 50, 5, 'gram'),
(185, 9, 38, 2, 'gram'),
(186, 9, 44, 10, 'ml'),
(187, 10, 83, 1, 'pcs'),
(188, 10, 82, 1, 'pcs'),
(189, 10, 74, 5, 'gram'),
(190, 10, 32, 1, 'gram'),
(191, 10, 38, 2, 'gram');

-- --------------------------------------------------------

--
-- Struktur dari tabel `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `order_number` varchar(20) NOT NULL,
  `table_number` int(11) NOT NULL,
  `payment_method` enum('cash','qris') NOT NULL,
  `status` enum('Pending','Diproses','Selesai') NOT NULL DEFAULT 'Pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `orders`
--

INSERT INTO `orders` (`order_id`, `order_number`, `table_number`, `payment_method`, `status`, `created_at`, `completed_at`) VALUES
(16, 'NR-20251123-002', 13, 'cash', 'Pending', '2025-11-23 13:19:10', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `menu_id`, `quantity`, `subtotal`, `note`) VALUES
(13, 16, 27, 1, 13000.00, 'esnya dikit aja');

-- --------------------------------------------------------

--
-- Struktur dari tabel `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `payment_method` enum('cash','qris') NOT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `amount` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','success','failed') DEFAULT 'pending',
  `transaction_ref` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `payments`
--

INSERT INTO `payments` (`payment_id`, `order_id`, `payment_method`, `payment_date`, `amount`, `status`, `transaction_ref`) VALUES
(8, 16, 'cash', '2025-11-23 13:19:10', 13000.00, 'pending', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `stock_logs`
--

CREATE TABLE `stock_logs` (
  `stock_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `change_amount` int(11) NOT NULL,
  `reason` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `stock_logs`
--

INSERT INTO `stock_logs` (`stock_id`, `inventory_id`, `change_amount`, `reason`, `created_at`) VALUES
(1, 3, 0, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(2, 20, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(3, 19, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(4, 31, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(5, 36, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(6, 38, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(7, 18, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(8, 40, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(9, 76, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(10, 7, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(11, 12, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(12, 19, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(13, 38, -1, 'Auto-reduce for order NR-20251122-001', '2025-11-23 08:26:53'),
(14, 1, 0, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(15, 20, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(16, 19, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(17, 29, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(18, 24, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(19, 26, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(20, 38, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(21, 40, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(22, 44, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(23, 10, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(24, 14, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(25, 74, -1, 'Auto-reduce for order NR-20251123-003', '2025-11-23 09:27:13'),
(26, 5, 0, 'Auto-reduce for order NR-20251123-002', '2025-11-23 09:35:10'),
(27, 31, -1, 'Auto-reduce for order NR-20251123-002', '2025-11-23 09:35:10'),
(28, 19, -1, 'Auto-reduce for order NR-20251123-002', '2025-11-23 09:35:10'),
(29, 48, -1, 'Auto-reduce for order NR-20251123-002', '2025-11-23 09:35:10'),
(30, 38, -1, 'Auto-reduce for order NR-20251123-002', '2025-11-23 09:35:10'),
(31, 51, -1, 'Auto-reduce for order NR-20251123-001', '2025-11-23 09:35:11'),
(32, 10, -1, 'Auto-reduce for order NR-20251123-001', '2025-11-23 09:35:11'),
(33, 58, -1, 'Auto-reduce for order NR-20251123-001', '2025-11-23 09:35:11'),
(34, 76, -1, 'Auto-reduce for order NR-20251123-001', '2025-11-23 09:35:11'),
(35, 54, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(36, 81, 0, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(37, 77, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(38, 52, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(39, 53, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(40, 58, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(41, 17, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(42, 76, -1, 'Auto-reduce for order NR-20251122-003', '2025-11-23 09:35:12'),
(43, 51, -1, 'Auto-reduce for order NR-20251122-002', '2025-11-23 09:35:13'),
(44, 68, 0, 'Auto-reduce for order NR-20251122-002', '2025-11-23 09:35:13'),
(45, 15, -1, 'Auto-reduce for order NR-20251122-002', '2025-11-23 09:35:13'),
(46, 40, -1, 'Auto-reduce for order NR-20251122-002', '2025-11-23 09:35:13'),
(47, 54, 50, 'manual', '2025-11-23 14:06:10');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tracking`
--

CREATE TABLE `tracking` (
  `tracking_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `status` enum('in_kitchen','out_for_delivery','delivered') DEFAULT 'in_kitchen',
  `updated_at` datetime DEFAULT current_timestamp(),
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','kitchen') DEFAULT 'admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `role`) VALUES
(1, 'admin', 'admin123', 'admin'),
(2, 'kitchen', 'kitchen123', 'kitchen');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indeks untuk tabel `chefs`
--
ALTER TABLE `chefs`
  ADD PRIMARY KEY (`chef_id`);

--
-- Indeks untuk tabel `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`inventory_id`);

--
-- Indeks untuk tabel `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`menu_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indeks untuk tabel `menu_recipes`
--
ALTER TABLE `menu_recipes`
  ADD PRIMARY KEY (`recipes_id`),
  ADD KEY `menu_id` (`menu_id`),
  ADD KEY `inventory_id` (`inventory_id`);

--
-- Indeks untuk tabel `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_number` (`order_number`);

--
-- Indeks untuk tabel `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indeks untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indeks untuk tabel `stock_logs`
--
ALTER TABLE `stock_logs`
  ADD PRIMARY KEY (`stock_id`),
  ADD KEY `inventory_id` (`inventory_id`);

--
-- Indeks untuk tabel `tracking`
--
ALTER TABLE `tracking`
  ADD PRIMARY KEY (`tracking_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `carts`
--
ALTER TABLE `carts`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `chefs`
--
ALTER TABLE `chefs`
  MODIFY `chef_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `inventory`
--
ALTER TABLE `inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT untuk tabel `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT untuk tabel `menu_recipes`
--
ALTER TABLE `menu_recipes`
  MODIFY `recipes_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=192;

--
-- AUTO_INCREMENT untuk tabel `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `stock_logs`
--
ALTER TABLE `stock_logs`
  MODIFY `stock_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT untuk tabel `tracking`
--
ALTER TABLE `tracking`
  MODIFY `tracking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `menu_recipes`
--
ALTER TABLE `menu_recipes`
  ADD CONSTRAINT `menu_recipes_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menu_items` (`menu_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `menu_recipes_ibfk_2` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu_items` (`menu_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `stock_logs`
--
ALTER TABLE `stock_logs`
  ADD CONSTRAINT `stock_logs_ibfk_1` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `tracking`
--
ALTER TABLE `tracking`
  ADD CONSTRAINT `tracking_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
