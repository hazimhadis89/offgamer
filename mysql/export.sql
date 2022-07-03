-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.28 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for offgamer
CREATE DATABASE IF NOT EXISTS `offgamer` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `offgamer`;

-- Dumping structure for table offgamer.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `status` enum('Pending','In Progress','Complete') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `local_currency` enum('USD','MYR') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'USD',
  `local_amount` decimal(20,6) DEFAULT NULL,
  `exchange_rate` decimal(20,6) DEFAULT NULL,
  `usd_amount` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `point_used` int DEFAULT NULL,
  `type` enum('Normal','Promotion') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Normal',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `orders_user_id_foreign` (`user_id`),
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1049 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table offgamer.orders: ~6 rows (approximately)
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
REPLACE INTO `orders` (`id`, `user_id`, `status`, `local_currency`, `local_amount`, `exchange_rate`, `usd_amount`, `point_used`, `type`, `created_at`, `updated_at`) VALUES
	(1001, 1, 'Complete', 'USD', NULL, NULL, 800.000000, NULL, 'Normal', '2022-05-01 12:10:10', '2022-05-08 12:10:10'),
	(1002, 2, 'Complete', 'MYR', 114.540000, 4.410000, 25.990000, NULL, 'Normal', '2022-05-07 05:28:55', '2022-05-14 05:28:55'),
	(1003, 2, 'Complete', 'MYR', 3142.150000, 4.410000, 712.990000, NULL, 'Promotion', '2022-05-19 17:17:00', '2022-05-26 17:17:00'),
	(1004, 2, 'In Progress', 'MYR', 528.840000, 4.410000, 120.000000, NULL, 'Promotion', '2022-05-22 22:47:16', '2022-05-29 22:47:16'),
	(1005, 2, 'Pending', 'MYR', 1582.110000, 4.410000, 359.000000, NULL, 'Promotion', '2022-05-27 08:15:07', '2022-06-03 08:15:07'),
	(1006, 1, 'Pending', 'USD', NULL, NULL, 800.000000, NULL, 'Normal', '2007-06-01 06:35:59', '2007-06-08 06:35:59');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- Dumping structure for table offgamer.order_product
CREATE TABLE IF NOT EXISTS `order_product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned NOT NULL,
  `item_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `normal_price` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `promotion_price` decimal(20,6) NOT NULL DEFAULT '0.000000',
  PRIMARY KEY (`id`),
  KEY `order_product_order_id_foreign` (`order_id`),
  CONSTRAINT `order_product_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table offgamer.order_product: ~0 rows (approximately)
/*!40000 ALTER TABLE `order_product` DISABLE KEYS */;
REPLACE INTO `order_product` (`id`, `order_id`, `item_name`, `normal_price`, `promotion_price`) VALUES
	(2000, 1001, 'Radio', 80.000000, 712.990000),
	(2001, 1002, 'Portable Audio', 16.000000, 15.000000),
	(2002, 1002, 'THE SIMS', 9.990000, 8.790000),
	(2003, 1003, 'Radio', 80.000000, 712.990000),
	(2004, 1004, 'Scanner', 124.000000, 120.000000),
	(2005, 1005, 'Portable Audio', 16.000000, 15.000000),
	(2006, 1005, 'Radio', 80.000000, 712.990000),
	(2007, 1006, 'Camcorders', 359.000000, 303.000000),
	(2008, 1006, 'Radio', 80.000000, 712.990000);
/*!40000 ALTER TABLE `order_product` ENABLE KEYS */;

-- Dumping structure for table offgamer.rewards
CREATE TABLE IF NOT EXISTS `rewards` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `point_total` int unsigned NOT NULL DEFAULT '0',
  `point_balance` int unsigned NOT NULL DEFAULT '0',
  `expired_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `rewards_order_id_foreign` (`order_id`) USING BTREE,
  CONSTRAINT `rewards_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=218 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table offgamer.rewards: ~0 rows (approximately)
/*!40000 ALTER TABLE `rewards` DISABLE KEYS */;
/*!40000 ALTER TABLE `rewards` ENABLE KEYS */;

-- Dumping structure for table offgamer.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table offgamer.users: ~1 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
REPLACE INTO `users` (`id`, `name`) VALUES
	(1, 'John Smith'),
	(2, 'Jane Doe'),
	(3, 'James Clarke');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
