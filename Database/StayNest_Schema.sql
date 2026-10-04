-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: staynest
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `hotel_id` int DEFAULT NULL,
  `room_id` int DEFAULT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELLED') DEFAULT 'PENDING',
  `number_of_rooms` int DEFAULT '1',
  `booking_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `user_id` (`user_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (2,4,7,7,'2026-08-20','2026-08-23',15000.00,'CONFIRMED',2,'2026-08-21 12:24:22'),(3,4,15,78,'2026-08-18','2026-08-21',49500.00,'CONFIRMED',3,'2026-08-21 12:24:22'),(4,4,15,15,'2026-08-19','2026-08-20',2500.00,'CONFIRMED',1,'2026-08-21 12:24:22'),(5,4,2,2,'2026-08-18','2026-08-26',40000.00,'PENDING',2,'2026-08-21 12:24:22'),(6,3,7,70,'2026-08-18','2026-08-24',66000.00,'CONFIRMED',2,'2026-08-21 12:24:22'),(7,3,2,2,'2026-08-18','2026-08-20',10000.00,'PENDING',2,'2026-08-21 12:24:22'),(8,4,6,69,'2026-08-19','2026-08-21',22000.00,'PENDING',2,'2026-08-21 12:24:22'),(9,5,2,2,'2026-08-23','2026-08-24',5000.00,'CONFIRMED',2,'2026-08-21 12:24:22');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `hotel_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `location` varchar(255) NOT NULL,
  `description` text,
  `amenities` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`hotel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'ITC Royal Bengal','Kolkata, West Bengal','An opulent luxury hotel offering grand architecture, expansive views, and business facilities.','Fine Dining, Spa, Pool, Gym, Free WiFi'),(2,'Taj Bengal','Kolkata, West Bengal','A landmark 5-star property situated in the exclusive Alipore neighborhood with lavish heritage decor.','Pool, Spa, Heritage Walk, Bar, Gym'),(3,'The Oberoi Grand','Kolkata, West Bengal','Often referred to as the Grande Dame of Chowringhee, featuring classic colonial architecture.','Courtyard Pool, Spa, Luxury Dining, Free WiFi'),(4,'JW Marriott Hotel','Kolkata, West Bengal','Premium hotel offering contemporary rooms, a vibrant nightclub, and a luxury spa sanctuary.','Nightclub, Infinity Pool, Spa, Buffet, Gym'),(5,'Hyatt Regency','Kolkata, West Bengal','A premium 5-star hotel in Salt Lake featuring lush tropical greenery and exceptional dining.','Spa, Tennis Court, Pool, Gym'),(6,'ITC Sonar, a Luxury Collection Hotel','Kolkata, West Bengal','A luxury business resort designed celebrating the golden era of Bengal with distinct water gardens.','Lily Ponds, Spa, Multiple Restaurants, Gym'),(7,'The Park','Kolkata, West Bengal','A boutique 5-star property situated on historic Park Street, famous for its vibrant nightlife.','Nightclub, Spa, Pool, Premium Dining'),(8,'The Elgin, Darjeeling','Darjeeling, West Bengal','A heritage luxury resort offering a colonial-era experience with majestic Himalayan views.','Library, Spa, Vintage Bar, Mountain View'),(9,'MAYFAIR Darjeeling','Darjeeling, West Bengal','A beautiful hill resort offering classic Indian hospitality amid lush green valleys.','Game Room, Spa, Dining, Library, Free WiFi'),(10,'Cedar Inn','Darjeeling, West Bengal','Boutique hotel known for exceptional hospitality and stunning views of Mount Kanchenjunga.','Rooftop Cafe, Mountain View, Free WiFi, Transport'),(11,'Ramada by Wyndham','Darjeeling, West Bengal','Centrally located luxury property with a heated pool and easy access to the famous Darjeeling Mall.','Heated Pool, Gym, Free WiFi, Mountain View'),(12,'Taj Chia Kutir Resort & Spa','Kurseong, West Bengal','Set in a sprawling tea estate, offering eco-friendly luxury and panoramic views of the hills.','Tea Tasting, Spa, Indoor Pool, Fine Dining'),(13,'The Elgin Silver Oaks','Kalimpong, West Bengal','A boutique heritage hotel famous for its landscaped gardens and vintage colonial charm.','Garden Walk, Mountain View, Bar, Free WiFi'),(14,'MAYFAIR Himalayan Spa Resort','Kalimpong, West Bengal','Idyllic and well-maintained resort providing premium spa services and a peaceful atmosphere.','Spa, Gym, Pool, Mountain View'),(15,'Courtyard By Marriott','Siliguri, West Bengal','A modern midtown hotel with an exceptional rooftop bar and state-of-the-art facilities.','Rooftop Bar, Pool, Gym, Free WiFi'),(16,'MAYFAIR Tea Resort','Siliguri, West Bengal','Indias first boutique tea resort, combining luxurious stay with rich tea heritage.','Tea Tours, Spa, Fine Dining, Vintage Decor'),(17,'Fortune Select','Siliguri, West Bengal','A modern, upscale hotel offering seamless comfort for business and leisure travelers alike.','Pool, Gym, Bar, Free WiFi'),(18,'Hotel Sonar Bangla','Mandarmani, West Bengal','A popular beachfront resort offering stunning views of the Bay of Bengal and premium comfort.','Beachfront, Pool, Seafood Dining, Free WiFi'),(19,'Grand Beach Resort','Mandarmani, West Bengal','A luxury seaside resort boasting spacious rooms, excellent services, and a pristine beach.','Private Beach, Pool, Spa, Sea View'),(20,'Sher Bengal Beach Resort','Mandarmani, West Bengal','A well-equipped resort offering a relaxing atmosphere and a wonderful spa sanctuary.','Spa, Pool, Beach Access, Restaurant'),(21,'Coral Beach Resort','Mandarmani, West Bengal','A fabulous beach property featuring private beach access and highly rated customer service.','Beach Access, Pool, Spa, Sea View'),(22,'Digha Sea Resort','Digha, West Bengal','A luxurious sea-facing property in New Digha offering excellent amenities and beachfront views.','Sea View, Pool, Free WiFi, Multi-cuisine Restaurant'),(23,'Taj Ganga Kutir Resort & Spa','Raichak, West Bengal','A serene luxury retreat sitting along the banks of the Ganges River, ideal for weekend escapes.','River View, Spa, Outdoor Pool, Private Dining'),(24,'Sinclairs Retreat Dooars','Chalsa, West Bengal','A nature resort spread across a sprawling campus, offering proximity to wildlife sanctuaries.','Wildlife Safaris, Pool, Gym, Organic Farm'),(25,'ADB Kanvas','Lataguri, West Bengal','A popular resort for nature lovers offering comfortable stays near the Gorumara National Park.','Jungle Safari, Pool, Restaurant, Garden'),(26,'Sundarban Jungle Mahal Resort','Sundarbans, West Bengal','An eco-friendly resort acting as the perfect gateway to explore the famous mangrove forests.','Boat Safaris, Folk Dance, Local Cuisine, Nature Walks'),(27,'The Anthill','Santiniketan, West Bengal','A beautiful blend of comfort, art, and thoughtful design perfectly capturing the essence of Tagore land.','Art Gallery, Garden, Free WiFi, Organic Dining'),(28,'Mohor Kutir Resorts','Santiniketan, West Bengal','A highly-rated resort providing a tranquil, rustic experience with modern luxury amenities.','Pool, Traditional Food, Garden, Cultural Shows'),(29,'Bari Kothi Heritage Hotel','Murshidabad, West Bengal','A beautifully restored 18th-century palace offering a royal experience and traditional Bengali hospitality.','Heritage Tours, Royal Dining, Library, Cultural Events'),(30,'Hotel Sonar Bangla','Tarapith, West Bengal','A peaceful resort near the famous temple, offering comfortable luxury and serene surroundings.','Temple Assistance, Pool, Garden, Free Parking'),(31,'Fortune Park Pushpanjali','Durgapur, West Bengal','A premium ITC hotel in the heart of the city offering luxury for business and leisure travelers.','Pool, Gym, Fine Dining, Free WiFi'),(32,'The Grand','Asansol, West Bengal','A highly-rated, wonderful property providing excellent ambience and top-tier room service.','Restaurant, Gym, Free Parking, Bar'),(33,'Peerless Hotel','Durgapur, West Bengal','A well-maintained, long-standing property located near Gandhi More.','Restaurant, Garden, Meeting Rooms, Free WiFi'),(34,'Hotel Asansol International','Asansol, West Bengal','A spacious property featuring an outdoor swimming pool, comfortable rooms, and excellent dining.','Outdoor Pool, Garden, Shared Lounge, Free Parking'),(35,'The Citi Residenci Hotel','Asansol, West Bengal','A pleasant hotel featuring air-conditioned rooms, a bar, and excellent city accessibility.','Bar, AC, Room Service, Free WiFi'),(36,'Sonkupi Banjara Camp','Baghmundi, Purulia, West Bengal','An eco-tourism camp offering a rustic experience close to nature and local tribal culture.','Campfires, Nature Walks, Local Cuisine, Tent Stays'),(37,'Baranti Eco Resort','Muraddi, Purulia, West Bengal','A stunning resort situated a minute walk from Baranti Dam, offering elegantly designed suites and cottages.','Spa, Gym, Water Sports, Private Balcony'),(38,'Akash Hilltop Resort','Ajodhya Hill, Purulia, West Bengal','A peaceful resort perched on Ajodhya Hill, offering comfortable stays with majestic valley views.','Mountain View, Garden, Room Service, Dining'),(39,'Allure De Baranti','Muraddi, Purulia, West Bengal','A highly-rated hotel near the lake, offering Swiss cottages, bonfires, and a luxurious stay.','Bonfire, Restaurant, Lake View, AC Rooms'),(40,'Banalata Hotel','Joypur Forest, Bankura, West Bengal','A beautiful nature retreat located near the Joypur Forest, perfect for relaxing family getaways.','Forest Walks, Restaurant, Organic Farm, Parking'),(41,'Hotel Greenland Towers','Kharagpur, West Bengal','An excellent 3-star property offering comfortable stays with good views and spacious rooms.','Restaurant, AC, Parking, Free WiFi'),(42,'Wonder Country Club & Resort','Kharagpur, West Bengal','A highly-rated resort providing a relaxing environment, spacious rooms, and family-friendly amenities.','Pool, Garden, Restaurant, Couple Friendly'),(43,'Hotel Dreams Inn and Resort','Kharagpur, West Bengal','A very good, clean, and comfortable property known for its attentive staff and pleasant atmosphere.','Room Service, Free WiFi, Restaurant, AC'),(44,'Hotel Vinayak','Kharagpur, West Bengal','A popular choice offering international cuisine, guaranteed early check-ins, and a central location.','Restaurant, Early Check-in, AC, Parking'),(45,'Oracle Guest House','Kharagpur, West Bengal','A comfortable budget-friendly stay with dedicated parking and a welcoming environment.','Parking, Free WiFi, 24/7 Front Desk, AC');
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `role` enum('CUSTOMER','ADMIN') DEFAULT 'CUSTOMER',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Test Guest','guest@staynest.com','password123','9876543210','ADMIN','2026-08-13 12:58:02'),(3,'Pikuu Banerjee','banerjeeprerana50@gmail.com','Pikuu','6299104101','CUSTOMER','2026-08-13 14:03:13'),(4,'Debansu Maji','debansumajicr@gmail.com','Modi','7864908782','CUSTOMER','2026-08-13 14:27:12'),(5,'Debojyoti Banerjee','debojyotibanerjee45@gmail.com','100154','7001506551','CUSTOMER','2026-08-13 14:32:07');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-04 12:57:59
