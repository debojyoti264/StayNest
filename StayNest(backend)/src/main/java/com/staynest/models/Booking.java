package com.staynest.models;

public class Booking {
    private int bookingId;
    private int userId;
    private int hotelId;
    private int roomId; 
    private String checkInDate;
    private String checkOutDate;
    private double totalPrice;
    private String status;
    private int numberOfRooms;

    public Booking() {}

    public Booking(int bookingId, int userId, int hotelId, int roomId, String checkInDate, String checkOutDate, double totalPrice, String status, int numberOfRooms) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.hotelId = hotelId;
        this.roomId = roomId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.totalPrice = totalPrice;
        this.status = status;
        this.numberOfRooms = numberOfRooms;
    }

    // --- GETTERS (This removes the yellow warnings!) ---
    public int getBookingId() { return bookingId; }
    public int getUserId() { return userId; }
    public int getHotelId() { return hotelId; }
    public int getRoomId() { return roomId; }
    public String getCheckInDate() { return checkInDate; }
    public String getCheckOutDate() { return checkOutDate; }
    public double getTotalPrice() { return totalPrice; }
    public String getStatus() { return status; }
    public int getNumberOfRooms() { return numberOfRooms; }

    // --- SETTERS ---
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public void setStatus(String status) { this.status = status; }
    public void setNumberOfRooms(int numberOfRooms) { this.numberOfRooms = numberOfRooms; }
}