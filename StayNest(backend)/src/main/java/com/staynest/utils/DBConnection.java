package com.staynest.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Database URL pointing to our StayNest database
    private static final String URL = "jdbc:mysql://localhost:3306/StayNest";
    private static final String USER = "root"; // Usually 'root' by default
    private static final String PASSWORD = "100154db"; // Replace with your MySQL password

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // 1. Load the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 2. Establish the connection
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Success! Connected to the StayNest database.");
            
        } catch (ClassNotFoundException e) {
            System.out.println("Error: MySQL Driver not found. Did you put the .jar in the lib folder?");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Error: Database connection failed. Check your password and URL.");
            e.printStackTrace();
        }
        return connection;
    }

    // A small test method to verify our connection works
    public static void main(String[] args) {
        getConnection();
    }
}