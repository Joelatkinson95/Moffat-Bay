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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/* Handles the reservation lookup form on reservations.jsp.
   Accepts a confirmation ID (MB-00042 or bare number) or an email,
   joins reservation + users + rooms, and forwards the match to the summary section. */
@WebServlet("/LookupReservationServlet")
public class LookupReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Auth gate — lookup is scoped to the logged-in user's own reservations only.
        // Without this, anyone knowing an email or confirmation ID could read someone else's booking (IDOR).
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String rawQuery = request.getParameter("query");
        String query = rawQuery == null ? "" : rawQuery.trim();

        // No query on a lookup visit = just show the empty search form. Don't auto-list.
        if (query.isEmpty()) {
            request.setAttribute("view", "lookup");
            request.getRequestDispatcher("reservations.jsp").forward(request, response);
            return;
        }

        // Query present — decide ID vs email path. Both scope to logged-in user (IDOR protection).
        Integer byId = parseConfirmationId(query);

        String sql = (byId != null)
                ? baseSelect() + "WHERE r.reservation_id = ? AND r.user_id = ? LIMIT 1"
                : baseSelect() + "WHERE u.user_email = ? AND r.user_id = ? ORDER BY r.reservation_checkIn DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (byId != null) {
                stmt.setInt(1, byId);
                stmt.setInt(2, userId);
            } else {
                stmt.setString(1, query);
                stmt.setInt(2, userId);
            }

            List<Reservation> results = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) results.add(mapRow(rs));
            }

            // Only remember searches that actually found something — skips typos.
            if (!results.isEmpty()) {
                rememberSearch(session, query);
            }

            if (results.isEmpty()) {
                request.setAttribute("lookupError", "No matching reservation found.");
                request.setAttribute("lookupQuery", query);
                request.setAttribute("view", "lookup");
            } else if (byId != null || results.size() == 1) {
                // ID lookup or email with exactly 1 match → drill straight to summary
                request.setAttribute("reservation", results.get(0));
                request.setAttribute("view", "summary");
            } else {
                // Multi-match email search — show a list on the lookup page
                request.setAttribute("reservations", results);
                request.setAttribute("lookupQuery", query);
                request.setAttribute("view", "lookup");
            }

            request.getRequestDispatcher("reservations.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Something went wrong looking up your reservation.", e);
        }
    }

    // Keeps the 5 most recent successful searches in session for quick re-running.
    // Dedupes (same query bubbles to the top) and caps at RECENT_LIMIT.
    private static final int RECENT_LIMIT = 5;
    @SuppressWarnings("unchecked")
    private static void rememberSearch(HttpSession session, String query) {
        List<String> recent = (List<String>) session.getAttribute("recentSearches");
        if (recent == null) recent = new ArrayList<>();
        recent.remove(query);
        recent.add(0, query);
        while (recent.size() > RECENT_LIMIT) recent.remove(recent.size() - 1);
        session.setAttribute("recentSearches", recent);
    }

    private static Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setReservationId(rs.getInt("reservation_id"));
        res.setUserId(rs.getInt("user_id"));
        res.setRoomId(rs.getInt("room_id"));
        res.setRoomType(rs.getString("room_type"));
        res.setRoomPrice(rs.getBigDecimal("room_price"));
        res.setCheckIn(rs.getDate("reservation_checkIn"));
        res.setCheckOut(rs.getDate("reservation_checkOut"));
        res.setGuestAmount(rs.getInt("reservation_guestAmount"));
        res.setStatus(rs.getString("reservation_status"));
        res.setGuestName(rs.getString("user_firstName") + " " + rs.getString("user_lastName"));
        res.setGuestEmail(rs.getString("user_email"));
        res.setGuestPhone(rs.getString("user_phoneNumber"));
        long nights = res.getCheckOut().toLocalDate().toEpochDay()
                    - res.getCheckIn().toLocalDate().toEpochDay();
        if (nights < 1) nights = 1;
        res.setFinalPrice(res.getRoomPrice().multiply(java.math.BigDecimal.valueOf(nights)));
        return res;
    }

    private static String baseSelect() {
        return "SELECT r.reservation_id, r.user_id, r.room_id, r.reservation_checkIn, " +
               "       r.reservation_checkOut, r.reservation_guestAmount, r.reservation_status, " +
               "       rm.room_type, rm.room_price, " +
               "       u.user_email, u.user_firstName, u.user_lastName, u.user_phoneNumber " +
               "FROM reservation r " +
               "JOIN rooms rm ON r.room_id = rm.room_id " +
               "JOIN users u ON r.user_id = u.user_id ";
    }

    // Accepts "MB-00042", "mb-42", or "42" — returns the numeric id or null if not a confirmation ID
    private static Integer parseConfirmationId(String q) {
        String cleaned = q.replaceAll("(?i)^mb-?", "").trim();
        if (cleaned.isEmpty() || !cleaned.matches("\\d+")) return null;
        try { return Integer.parseInt(cleaned); } catch (NumberFormatException e) { return null; }
    }
}
