package com.staynest.models;

public class Hotel {
    private int hotelId;
    private String name;
    private String location;
    private String description;
    private String amenities;
    private double startingPrice; // 🌟 NEW VARIABLE

    public Hotel() {}

    // 🌟 UPDATED CONSTRUCTOR
    public Hotel(int hotelId, String name, String location, String description, String amenities, double startingPrice) {
        this.hotelId = hotelId;
        this.name = name;
        this.location = location;
        this.description = description;
        this.amenities = amenities;
        this.startingPrice = startingPrice;
    }

    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAmenities() { return amenities; }
    public void setAmenities(String amenities) { this.amenities = amenities; }

    // 🌟 NEW GETTER & SETTER
    public double getStartingPrice() { return startingPrice; }
    public void setStartingPrice(double startingPrice) { this.startingPrice = startingPrice; }
}