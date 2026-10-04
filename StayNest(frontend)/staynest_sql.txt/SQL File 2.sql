-- 1. Reset & Create the StayNest Database
DROP DATABASE IF EXISTS StayNest;
CREATE DATABASE StayNest;
USE StayNest;

-- 2. Create the Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15),
    role ENUM('CUSTOMER', 'ADMIN') DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Create the Hotels Table
CREATE TABLE Hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(255) NOT NULL,
    description TEXT,
    amenities VARCHAR(255)
);

-- 4. Create the Rooms Table
CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    room_type VARCHAR(50) NOT NULL, 
    price_per_night DECIMAL(10, 2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id) ON DELETE CASCADE
);

-- 5. Create the Bookings Table
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    room_id INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED') DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ON DELETE CASCADE
);

-- 6. Insert All 45 West Bengal Hotel Records
INSERT INTO Hotels (name, location, description, amenities) VALUES
-- 🏙️ KOLKATA
('ITC Royal Bengal', 'Kolkata, West Bengal', 'An opulent luxury hotel offering grand architecture, expansive views, and business facilities.', 'Fine Dining, Spa, Pool, Gym, Free WiFi'),
('Taj Bengal', 'Kolkata, West Bengal', 'A landmark 5-star property situated in the exclusive Alipore neighborhood with lavish heritage decor.', 'Pool, Spa, Heritage Walk, Bar, Gym'),
('The Oberoi Grand', 'Kolkata, West Bengal', 'Often referred to as the Grande Dame of Chowringhee, featuring classic colonial architecture.', 'Courtyard Pool, Spa, Luxury Dining, Free WiFi'),
('JW Marriott Hotel', 'Kolkata, West Bengal', 'Premium hotel offering contemporary rooms, a vibrant nightclub, and a luxury spa sanctuary.', 'Nightclub, Infinity Pool, Spa, Buffet, Gym'),
('Hyatt Regency', 'Kolkata, West Bengal', 'A premium 5-star hotel in Salt Lake featuring lush tropical greenery and exceptional dining.', 'Spa, Tennis Court, Pool, Gym'),
('ITC Sonar, a Luxury Collection Hotel', 'Kolkata, West Bengal', 'A luxury business resort designed celebrating the golden era of Bengal with distinct water gardens.', 'Lily Ponds, Spa, Multiple Restaurants, Gym'),
('The Park', 'Kolkata, West Bengal', 'A boutique 5-star property situated on historic Park Street, famous for its vibrant nightlife.', 'Nightclub, Spa, Pool, Premium Dining'),

-- 🏔️ DARJEELING & KURSEONG
('The Elgin, Darjeeling', 'Darjeeling, West Bengal', 'A heritage luxury resort offering a colonial-era experience with majestic Himalayan views.', 'Library, Spa, Vintage Bar, Mountain View'),
('MAYFAIR Darjeeling', 'Darjeeling, West Bengal', 'A beautiful hill resort offering classic Indian hospitality amid lush green valleys.', 'Game Room, Spa, Dining, Library, Free WiFi'),
('Cedar Inn', 'Darjeeling, West Bengal', 'Boutique hotel known for exceptional hospitality and stunning views of Mount Kanchenjunga.', 'Rooftop Cafe, Mountain View, Free WiFi, Transport'),
('Ramada by Wyndham', 'Darjeeling, West Bengal', 'Centrally located luxury property with a heated pool and easy access to the famous Darjeeling Mall.', 'Heated Pool, Gym, Free WiFi, Mountain View'),
('Taj Chia Kutir Resort & Spa', 'Kurseong, West Bengal', 'Set in a sprawling tea estate, offering eco-friendly luxury and panoramic views of the hills.', 'Tea Tasting, Spa, Indoor Pool, Fine Dining'),

-- ⛰️ KALIMPONG & SILIGURI
('The Elgin Silver Oaks', 'Kalimpong, West Bengal', 'A boutique heritage hotel famous for its landscaped gardens and vintage colonial charm.', 'Garden Walk, Mountain View, Bar, Free WiFi'),
('MAYFAIR Himalayan Spa Resort', 'Kalimpong, West Bengal', 'Idyllic and well-maintained resort providing premium spa services and a peaceful atmosphere.', 'Spa, Gym, Pool, Mountain View'),
('Courtyard By Marriott', 'Siliguri, West Bengal', 'A modern midtown hotel with an exceptional rooftop bar and state-of-the-art facilities.', 'Rooftop Bar, Pool, Gym, Free WiFi'),
('MAYFAIR Tea Resort', 'Siliguri, West Bengal', 'Indias first boutique tea resort, combining luxurious stay with rich tea heritage.', 'Tea Tours, Spa, Fine Dining, Vintage Decor'),
('Fortune Select', 'Siliguri, West Bengal', 'A modern, upscale hotel offering seamless comfort for business and leisure travelers alike.', 'Pool, Gym, Bar, Free WiFi'),

-- 🌊 MANDARMANI, DIGHA & RAICHAK
('Hotel Sonar Bangla', 'Mandarmani, West Bengal', 'A popular beachfront resort offering stunning views of the Bay of Bengal and premium comfort.', 'Beachfront, Pool, Seafood Dining, Free WiFi'),
('Grand Beach Resort', 'Mandarmani, West Bengal', 'A luxury seaside resort boasting spacious rooms, excellent services, and a pristine beach.', 'Private Beach, Pool, Spa, Sea View'),
('Sher Bengal Beach Resort', 'Mandarmani, West Bengal', 'A well-equipped resort offering a relaxing atmosphere and a wonderful spa sanctuary.', 'Spa, Pool, Beach Access, Restaurant'),
('Coral Beach Resort', 'Mandarmani, West Bengal', 'A fabulous beach property featuring private beach access and highly rated customer service.', 'Beach Access, Pool, Spa, Sea View'),
('Digha Sea Resort', 'Digha, West Bengal', 'A luxurious sea-facing property in New Digha offering excellent amenities and beachfront views.', 'Sea View, Pool, Free WiFi, Multi-cuisine Restaurant'),
('Taj Ganga Kutir Resort & Spa', 'Raichak, West Bengal', 'A serene luxury retreat sitting along the banks of the Ganges River, ideal for weekend escapes.', 'River View, Spa, Outdoor Pool, Private Dining'),

-- 🐅 DOOARS & SUNDARBANS
('Sinclairs Retreat Dooars', 'Chalsa, West Bengal', 'A nature resort spread across a sprawling campus, offering proximity to wildlife sanctuaries.', 'Wildlife Safaris, Pool, Gym, Organic Farm'),
('ADB Kanvas', 'Lataguri, West Bengal', 'A popular resort for nature lovers offering comfortable stays near the Gorumara National Park.', 'Jungle Safari, Pool, Restaurant, Garden'),
('Sundarban Jungle Mahal Resort', 'Sundarbans, West Bengal', 'An eco-friendly resort acting as the perfect gateway to explore the famous mangrove forests.', 'Boat Safaris, Folk Dance, Local Cuisine, Nature Walks'),

-- 🎨 SANTINIKETAN, MURSHIDABAD & TARAPITH
('The Anthill', 'Santiniketan, West Bengal', 'A beautiful blend of comfort, art, and thoughtful design perfectly capturing the essence of Tagore land.', 'Art Gallery, Garden, Free WiFi, Organic Dining'),
('Mohor Kutir Resorts', 'Santiniketan, West Bengal', 'A highly-rated resort providing a tranquil, rustic experience with modern luxury amenities.', 'Pool, Traditional Food, Garden, Cultural Shows'),
('Bari Kothi Heritage Hotel', 'Murshidabad, West Bengal', 'A beautifully restored 18th-century palace offering a royal experience and traditional Bengali hospitality.', 'Heritage Tours, Royal Dining, Library, Cultural Events'),
('Hotel Sonar Bangla', 'Tarapith, West Bengal', 'A peaceful resort near the famous temple, offering comfortable luxury and serene surroundings.', 'Temple Assistance, Pool, Garden, Free Parking'),

-- 🏭 ASANSOL & DURGAPUR
('Fortune Park Pushpanjali', 'Durgapur, West Bengal', 'A premium ITC hotel in the heart of the city offering luxury for business and leisure travelers.', 'Pool, Gym, Fine Dining, Free WiFi'),
('The Grand', 'Asansol, West Bengal', 'A highly-rated, wonderful property providing excellent ambience and top-tier room service.', 'Restaurant, Gym, Free Parking, Bar'),
('Peerless Hotel', 'Durgapur, West Bengal', 'A well-maintained, long-standing property located near Gandhi More.', 'Restaurant, Garden, Meeting Rooms, Free WiFi'),
('Hotel Asansol International', 'Asansol, West Bengal', 'A spacious property featuring an outdoor swimming pool, comfortable rooms, and excellent dining.', 'Outdoor Pool, Garden, Shared Lounge, Free Parking'),
('The Citi Residenci Hotel', 'Asansol, West Bengal', 'A pleasant hotel featuring air-conditioned rooms, a bar, and excellent city accessibility.', 'Bar, AC, Room Service, Free WiFi'),

-- 🌄 PURULIA & BANKURA
('Sonkupi Banjara Camp', 'Baghmundi, Purulia, West Bengal', 'An eco-tourism camp offering a rustic experience close to nature and local tribal culture.', 'Campfires, Nature Walks, Local Cuisine, Tent Stays'),
('Baranti Eco Resort', 'Muraddi, Purulia, West Bengal', 'A stunning resort situated a minute walk from Baranti Dam, offering elegantly designed suites and cottages.', 'Spa, Gym, Water Sports, Private Balcony'),
('Akash Hilltop Resort', 'Ajodhya Hill, Purulia, West Bengal', 'A peaceful resort perched on Ajodhya Hill, offering comfortable stays with majestic valley views.', 'Mountain View, Garden, Room Service, Dining'),
('Allure De Baranti', 'Muraddi, Purulia, West Bengal', 'A highly-rated hotel near the lake, offering Swiss cottages, bonfires, and a luxurious stay.', 'Bonfire, Restaurant, Lake View, AC Rooms'),
('Banalata Hotel', 'Joypur Forest, Bankura, West Bengal', 'A beautiful nature retreat located near the Joypur Forest, perfect for relaxing family getaways.', 'Forest Walks, Restaurant, Organic Farm, Parking'),

-- 🎓 KHARAGPUR
('Hotel Greenland Towers', 'Kharagpur, West Bengal', 'An excellent 3-star property offering comfortable stays with good views and spacious rooms.', 'Restaurant, AC, Parking, Free WiFi'),
('Wonder Country Club & Resort', 'Kharagpur, West Bengal', 'A highly-rated resort providing a relaxing environment, spacious rooms, and family-friendly amenities.', 'Pool, Garden, Restaurant, Couple Friendly'),
('Hotel Dreams Inn and Resort', 'Kharagpur, West Bengal', 'A very good, clean, and comfortable property known for its attentive staff and pleasant atmosphere.', 'Room Service, Free WiFi, Restaurant, AC'),
('Hotel Vinayak', 'Kharagpur, West Bengal', 'A popular choice offering international cuisine, guaranteed early check-ins, and a central location.', 'Restaurant, Early Check-in, AC, Parking'),
('Oracle Guest House', 'Kharagpur, West Bengal', 'A comfortable budget-friendly stay with dedicated parking and a welcoming environment.', 'Parking, Free WiFi, 24/7 Front Desk, AC');

-- 7. Verify the Insertion
SELECT * FROM Hotels;