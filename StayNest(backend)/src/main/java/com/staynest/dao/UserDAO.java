package com.staynest.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.staynest.models.User;
import com.staynest.utils.DBConnection;

public class UserDAO {

    // 1. Method for SIGNUP: Inserts a new user into the database
    public boolean registerUser(User user) {
        String query = "INSERT INTO Users (full_name, email, password_hash, phone_number) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhoneNumber());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.out.println("Error registering user: Email might already exist.");
            e.printStackTrace();
            return false;
        }
    }

    // 2. Method for LOGIN: Checks if email and password match, then returns the User
    public User authenticateUser(String email, String password) {
        String query = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, email);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    // Note: We deliberately don't send the password back for security!
                    return user;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error authenticating user.");
            e.printStackTrace();
        }
        return null; // Returns null if login fails
    }
}