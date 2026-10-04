package com.staynest.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.staynest.models.Room;
import com.staynest.utils.DBConnection;

public class RoomDAO {
    
    public List<Room> getRoomsByHotelId(int hotelId) {
        List<Room> rooms = new ArrayList<>();
        // Fetch only available rooms for the selected hotel
        String query = "SELECT * FROM Rooms WHERE hotel_id = ? AND is_available = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, hotelId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setHotelId(rs.getInt("hotel_id"));
                room.setRoomType(rs.getString("room_type"));
                room.setPricePerNight(rs.getDouble("price_per_night"));
                room.setAvailable(rs.getBoolean("is_available"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching rooms.");
            e.printStackTrace();
        }
        return rooms;
    }
}