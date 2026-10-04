package com.staynest.servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

// 🌟 REMOVED: java.sql.Date import is gone because we now use Strings for dates!

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.staynest.dao.BookingDAO;
import com.staynest.models.Booking;

@WebServlet("/api/bookings")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    // 🌟 REQUIRED FOR REACT: Handles the "Pre-flight" CORS check before a request
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Enable CORS and set response type to JSON
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        try {
            // 2. Read the raw JSON text sent from React
            BufferedReader reader = request.getReader();
            JsonObject jsonRequest = gson.fromJson(reader, JsonObject.class);

            // 3. Extract all the data perfectly matching React's new JSON payload
            int userId = jsonRequest.get("userId").getAsInt(); 
            int hotelId = jsonRequest.get("hotelId").getAsInt(); // 🌟 NEW
            int roomId = jsonRequest.get("roomId").getAsInt();
            int numberOfRooms = jsonRequest.get("numberOfRooms").getAsInt(); // 🌟 NEW
            String checkIn = jsonRequest.get("checkInDate").getAsString(); // 🌟 CHANGED to String
            String checkOut = jsonRequest.get("checkOutDate").getAsString(); // 🌟 CHANGED to String
            double totalPrice = jsonRequest.get("totalPrice").getAsDouble();

         // 4. Put the data into our Booking blueprint using setters
            Booking newBooking = new Booking();
            newBooking.setUserId(userId);
            newBooking.setHotelId(hotelId);
            newBooking.setRoomId(roomId);
            newBooking.setNumberOfRooms(numberOfRooms);
            newBooking.setCheckInDate(checkIn);
            newBooking.setCheckOutDate(checkOut);
            newBooking.setTotalPrice(totalPrice);
            newBooking.setStatus("PENDING"); // 🌟 ADD THIS MISSING LINE!
            // (Status is automatically handled by the DAO)

            // 5. Save to database using the DAO
            boolean isSuccess = bookingDAO.createBooking(newBooking);

            // 6. Send a success or failure message back to React
            JsonObject jsonResponse = new JsonObject();
            if (isSuccess) {
                jsonResponse.addProperty("status", "success");
                jsonResponse.addProperty("message", "Booking saved to MySQL!");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Database insertion failed.");
            }
            out.print(gson.toJson(jsonResponse));

        } catch (Exception e) {
            e.printStackTrace();
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("status", "error");
            errorResponse.addProperty("message", "Invalid data format sent to server.");
            out.print(gson.toJson(errorResponse));
        } finally {
            out.flush();
        }
    }

    // Handles GET requests for Users AND Admins
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String userIdParam = request.getParameter("userId");
        String adminParam = request.getParameter("admin");
        PrintWriter out = response.getWriter();
        
        // If React sends "?admin=true", return EVERYTHING for the dashboard
        if ("true".equals(adminParam)) {
            java.util.List<Booking> allBookings = bookingDAO.getAllBookings();
            out.print(new Gson().toJson(allBookings));
        } 
        // Otherwise, return just the specific user's bookings
        else if (userIdParam != null) {
            int userId = Integer.parseInt(userIdParam);
            java.util.List<Booking> userBookings = bookingDAO.getBookingsByUserId(userId);
            out.print(new Gson().toJson(userBookings));
        }
        out.flush();
    }

    // Handles Soft Cancels (Users) AND Hard Deletes (Admins)
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String bookingIdParam = request.getParameter("bookingId");
        String actionParam = request.getParameter("action"); 
        
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();

        if (bookingIdParam != null) {
            int bookingId = Integer.parseInt(bookingIdParam);
            boolean isSuccess;
            
            // Check if the request is asking for a hard delete (Admin) or soft cancel (User)
            if ("hard_delete".equals(actionParam)) {
                isSuccess = bookingDAO.deleteBookingPermanently(bookingId);
                jsonResponse.addProperty("message", "Booking permanently erased from database.");
            } else {
                isSuccess = bookingDAO.cancelBooking(bookingId);
                jsonResponse.addProperty("message", "Booking successfully cancelled.");
            }

            if (isSuccess) {
                jsonResponse.addProperty("status", "success");
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Database operation failed.");
            }
        }
        
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}