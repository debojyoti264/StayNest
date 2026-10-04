package com.staynest.models;

public class Room {
    private int roomId;
    private int hotelId;
    private String roomType;
    private double pricePerNight;
    private boolean isAvailable;

    public Room() {}

    public Room(int roomId, int hotelId, String roomType, double pricePerNight, boolean isAvailable) {
        this.roomId = roomId;
        this.hotelId = hotelId;
        this.roomType = roomType;
        this.pricePerNight = pricePerNight;
        this.isAvailable = isAvailable;
    }

    // Getters
    public int getRoomId() { return roomId; }
    public int getHotelId() { return hotelId; }
    public String getRoomType() { return roomType; }
    public double getPricePerNight() { return pricePerNight; }
    public boolean isAvailable() { return isAvailable; }

    // Setters
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
    public void setPricePerNight(double pricePerNight) { this.pricePerNight = pricePerNight; }
    public void setAvailable(boolean isAvailable) { this.isAvailable = isAvailable; }
}