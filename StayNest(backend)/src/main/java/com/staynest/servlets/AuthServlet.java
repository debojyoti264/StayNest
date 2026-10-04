package com.staynest.servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.staynest.dao.UserDAO;
import com.staynest.models.User;

@WebServlet("/api/auth")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Handle CORS pre-flight requests from React
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();

        try {
            // 1. Read the incoming JSON data
            BufferedReader reader = request.getReader();
            JsonObject jsonRequest = gson.fromJson(reader, JsonObject.class);
            
            // 2. Determine if React wants to "login" or "register"
            String action = jsonRequest.has("action") ? jsonRequest.get("action").getAsString() : "";

            if ("register".equals(action)) {
                // REGISTRATION LOGIC
                String fullName = jsonRequest.get("fullName").getAsString();
                String email = jsonRequest.get("email").getAsString();
                String password = jsonRequest.get("password").getAsString();
                String phone = jsonRequest.has("phoneNumber") ? jsonRequest.get("phoneNumber").getAsString() : "";

                User newUser = new User(fullName, email, password, phone);
                boolean isSuccess = userDAO.registerUser(newUser);

                if (isSuccess) {
                    jsonResponse.addProperty("status", "success");
                    jsonResponse.addProperty("message", "Registration successful!");
                } else {
                    jsonResponse.addProperty("status", "error");
                    jsonResponse.addProperty("message", "Email already exists or invalid data.");
                }
            } 
            else if ("login".equals(action)) {
                // LOGIN LOGIC
                String email = jsonRequest.get("email").getAsString();
                String password = jsonRequest.get("password").getAsString();

                User loggedInUser = userDAO.authenticateUser(email, password);

                if (loggedInUser != null) {
                    jsonResponse.addProperty("status", "success");
                    jsonResponse.addProperty("message", "Login successful!");
                    
                    // Securely send the user details back (WITHOUT the password)
                    JsonObject userData = new JsonObject();
                    userData.addProperty("userId", loggedInUser.getUserId());
                    userData.addProperty("fullName", loggedInUser.getFullName());
                    userData.addProperty("email", loggedInUser.getEmail());
                    jsonResponse.add("user", userData);
                } else {
                    jsonResponse.addProperty("status", "error");
                    jsonResponse.addProperty("message", "Invalid email or password.");
                }
            } 
            else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Invalid action specified.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Server error processing authentication.");
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }
}