package com.staynest.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.staynest.models.Booking;
import com.staynest.utils.DBConnection;

public class BookingDAO {

    // Method to save a new booking into the database
    public boolean createBooking(Booking booking) {
        // 🌟 UPDATED: Added hotel_id and number_of_rooms placeholders
        String query = "INSERT INTO Bookings (user_id, hotel_id, room_id, check_in_date, check_out_date, total_price, number_of_rooms, status) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            // 🌟 UPDATED: Fill in all 8 placeholders, using setString for dates
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getHotelId()); 
            stmt.setInt(3, booking.getRoomId());
            stmt.setString(4, booking.getCheckInDate()); 
            stmt.setString(5, booking.getCheckOutDate()); 
            stmt.setDouble(6, booking.getTotalPrice());
            stmt.setInt(7, booking.getNumberOfRooms()); 
            stmt.setString(8, booking.getStatus()); 
            
            // Execute the insert. If rowsAffected > 0, it was successful!
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error creating booking in database.");
            e.printStackTrace();
            return false;
        }
    }

    // 🌟 NEW: Fetch all bookings for a specific user
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String query = "SELECT * FROM Bookings WHERE user_id = ? ORDER BY check_in_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setUserId(rs.getInt("user_id"));
                b.setHotelId(rs.getInt("hotel_id")); // 🌟 ADDED
                b.setRoomId(rs.getInt("room_id"));
                b.setCheckInDate(rs.getString("check_in_date")); // 🌟 CHANGED to getString
                b.setCheckOutDate(rs.getString("check_out_date")); // 🌟 CHANGED to getString
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setNumberOfRooms(rs.getInt("number_of_rooms")); // 🌟 ADDED
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching bookings.");
            e.printStackTrace();
        }
        return list;
    }

    // 🌟 NEW: Update a booking's status to CANCELLED
    public boolean cancelBooking(int bookingId) {
        String query = "UPDATE Bookings SET status = 'CANCELLED' WHERE booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, bookingId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error canceling booking.");
            e.printStackTrace();
            return false;
        }
    }

    // 🌟 ADMIN FEATURE: Fetch absolutely every booking in the database
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String query = "SELECT * FROM Bookings ORDER BY booking_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setUserId(rs.getInt("user_id"));
                b.setHotelId(rs.getInt("hotel_id")); // 🌟 ADDED
                b.setRoomId(rs.getInt("room_id"));
                b.setCheckInDate(rs.getString("check_in_date")); // 🌟 CHANGED to getString
                b.setCheckOutDate(rs.getString("check_out_date")); // 🌟 CHANGED to getString
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setNumberOfRooms(rs.getInt("number_of_rooms")); // 🌟 ADDED
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching all admin bookings.");
            e.printStackTrace();
        }
        return list;
    }

    // 🌟 ADMIN FEATURE: Permanently delete a booking from the database
    public boolean deleteBookingPermanently(int bookingId) {
        String query = "DELETE FROM Bookings WHERE booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, bookingId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error permanently deleting booking.");
            e.printStackTrace();
            return false;
        }
    }
}