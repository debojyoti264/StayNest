package com.staynest.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.staynest.dao.HotelDAO;
import com.staynest.models.Hotel;

@WebServlet("/api/hotels")
public class HotelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HotelDAO hotelDAO;

    @Override
    public void init() {
        hotelDAO = new HotelDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Enable CORS so React (running on a different port) can make requests
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 2. Fetch hotel data from MySQL
        List<Hotel> hotels = hotelDAO.getAllHotels();

        // 3. Convert Java List to JSON
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(hotels);

        // 4. Send JSON response to client
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }
}