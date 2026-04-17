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
   Looks up rooms that are not booked on the chosen dates
   and then sends the user to availability.jsp to pick one. */
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

        // This list will hold all the rooms that are free for those dates
        List<Room> availableRooms = new ArrayList<>();

        // SQL query: grab rooms that are available and not already booked for the chosen dates
        String sql =
                "SELECT room_id, room_type, room_price, room_status " +
                "FROM rooms " +
                "WHERE room_status = 'available' " +
                "AND room_id NOT IN ( " +
                "    SELECT room_id FROM reservation " +
                "    WHERE reservation_status = 'confirmed' " +
                "    AND ? < reservation_checkOut " +
                "    AND ? > reservation_checkIn " +
                ")";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Fill in the two date placeholders in the query
            stmt.setDate(1, Date.valueOf(checkIn));
            stmt.setDate(2, Date.valueOf(checkOut));

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("room_id"),
                        rs.getString("room_type"),
                        rs.getBigDecimal("room_price"),
                        rs.getString("room_status")
                );
                availableRooms.add(room);
            }

        } catch (SQLException e) {
            throw new ServletException("Something went wrong looking up rooms.", e);
        }

        // Save the data so availability.jsp can display it
        request.setAttribute("availableRooms", availableRooms);
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
