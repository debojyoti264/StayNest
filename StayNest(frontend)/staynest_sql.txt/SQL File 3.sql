USE StayNest;

-- 1. Create a "Standard Room" for every hotel in the database
INSERT INTO Rooms (hotel_id, room_type, price_per_night, is_available)
SELECT hotel_id, 'Standard Room', 2500.00, TRUE 
FROM Hotels;

-- 2. Create a "Deluxe Suite" for every hotel in the database
INSERT INTO Rooms (hotel_id, room_type, price_per_night, is_available)
SELECT hotel_id, 'Deluxe Suite', 5500.00, TRUE 
FROM Hotels;

-- Let's view the rooms for the first few hotels to verify!
SELECT h.name, r.room_type, r.price_per_night
FROM Hotels h
JOIN Rooms r ON h.hotel_id = r.hotel_id
ORDER BY h.hotel_id LIMIT 10;