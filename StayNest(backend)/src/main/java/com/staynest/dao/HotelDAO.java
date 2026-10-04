package com.staynest.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.staynest.models.Hotel;
import com.staynest.utils.DBConnection;

public class HotelDAO {

    public List<Hotel> getAllHotels() {
        List<Hotel> hotelList = new ArrayList<>();
        
        // 🌟 UPDATED QUERY: Joins Hotels with Rooms to get the lowest price
        String query = "SELECT h.*, MIN(r.price_per_night) as starting_price " +
                       "FROM Hotels h " +
                       "LEFT JOIN Rooms r ON h.hotel_id = r.hotel_id " +
                       "GROUP BY h.hotel_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Hotel hotel = new Hotel();
                hotel.setHotelId(rs.getInt("hotel_id"));
                hotel.setName(rs.getString("name"));
                hotel.setLocation(rs.getString("location"));
                hotel.setDescription(rs.getString("description"));
                hotel.setAmenities(rs.getString("amenities"));
                
                // 🌟 FETCH THE NEW PRICE COLUMN
                hotel.setStartingPrice(rs.getDouble("starting_price"));
                
                hotelList.add(hotel);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching hotels from the database.");
            e.printStackTrace();
        }

        return hotelList;
    }
}