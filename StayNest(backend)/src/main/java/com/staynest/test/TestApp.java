package com.staynest.test;

import java.util.List;
import com.staynest.dao.HotelDAO;
import com.staynest.models.Hotel;

public class TestApp {
    public static void main(String[] args) {
        // 1. Instantiate our DAO (the bridge to our database)
        HotelDAO hotelDAO = new HotelDAO();
        
        // 2. Fetch the list of all 45 hotels
        List<Hotel> staynestHotels = hotelDAO.getAllHotels();
        
        System.out.println("🌟 --- STAYNEST HOTEL DIRECTORY --- 🌟\n");
        
        // 3. Loop through the list and print out the details
        for (Hotel hotel : staynestHotels) {
            System.out.println("🏨 Name: " + hotel.getName());
            System.out.println("📍 Location: " + hotel.getLocation());
            System.out.println("✨ Amenities: " + hotel.getAmenities());
            System.out.println("--------------------------------------------------");
        }
        
        // Print the total count to verify we got everything
        System.out.println("\n✅ Total Hotels Successfully Fetched: " + staynestHotels.size());
    }
}