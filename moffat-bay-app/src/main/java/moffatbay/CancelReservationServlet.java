package moffatbay;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/* Flips a reservation from 'confirmed' to 'cancelled'.
   Auth-gated + user_id scoped so a user can only cancel their own bookings. */
@WebServlet("/CancelReservationServlet")
public class CancelReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int reservationId;
        try {
            reservationId = Integer.parseInt(request.getParameter("reservationId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("LookupReservationServlet");
            return;
        }

        // UPDATE with both reservation_id AND user_id in WHERE — can't cancel someone else's even by guessing IDs.
        // Only flips 'confirmed' rows so repeat clicks don't re-trigger the update.
        String sql = "UPDATE reservation SET reservation_status = 'cancelled' " +
                     "WHERE reservation_id = ? AND user_id = ? AND reservation_status = 'confirmed'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException("Something went wrong cancelling your reservation.", e);
        }

        // Bounce back to the summary so the user sees the status flipped to cancelled.
        response.sendRedirect("LookupReservationServlet?query=MB-" + String.format("%05d", reservationId));
    }
}
