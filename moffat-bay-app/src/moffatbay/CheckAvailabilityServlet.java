package moffatbay;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/* Handles the booking form on index.html.
   Checks which room TYPES have at least one room open for the chosen dates
   and sends the user to availability.jsp to pick a type. */
@WebServlet("/CheckAvailabilityServlet")
public class CheckAvailabilityServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the values the user picked on the landing page
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        int rooms = Integer.parseInt(request.getParameter("rooms"));
        int adults = Integer.parseInt(request.getParameter("adults"));
        int children = Integer.parseInt(request.getParameter("children"));
        int totalGuests = adults + children;

        // This list will hold the room types that have at least one room open
        List<Room> availableTypes = new ArrayList<>();

        // SQL: group by room type, count how many rooms of each type are free
        String sql =
                "SELECT room_type, room_price, COUNT(*) AS available_count " +
                "FROM rooms " +
                "WHERE room_status = 'available' " +
                "AND room_id NOT IN ( " +
                "    SELECT room_id FROM reservation " +
                "    WHERE reservation_status = 'confirmed' " +
                "    AND ? < reservation_checkOut " +
                "    AND ? > reservation_checkIn " +
                ") " +
                "GROUP BY room_type, room_price";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Fill in the date placeholders
            stmt.setDate(1, Date.valueOf(checkIn));
            stmt.setDate(2, Date.valueOf(checkOut));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room(
                        rs.getString("room_type"),
                        rs.getBigDecimal("room_price"),
                        rs.getInt("available_count")
                );
                availableTypes.add(room);
            }

        } catch (SQLException e) {
            throw new ServletException("Something went wrong looking up rooms.", e);
        }

        // Save the data so availability.jsp can display it
        request.setAttribute("availableTypes", availableTypes);
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("rooms", rooms);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("totalGuests", totalGuests);

        // Send the user to the results page
        request.getRequestDispatcher("availability.jsp").forward(request, response);
    }
}