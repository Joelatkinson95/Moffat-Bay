package moffatbay;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.regex.Pattern;

/* Handles the booking form on reservations.jsp.
   Picks an available room of the chosen type, inserts a reservation row,
   and forwards back to reservations.jsp with the summary populated. */
@WebServlet("/CreateReservationServlet")
public class CreateReservationServlet extends HttpServlet {

    private static final Pattern EMAIL = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONE = Pattern.compile("^\\(\\d{3}\\) \\d{3}-\\d{4}$");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require a logged-in user — booking needs a user_id FK
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Collect form values
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String roomType = request.getParameter("roomType");
        String adultsStr = request.getParameter("adults");
        String childrenStr = request.getParameter("children");
        String guestName = safe(request.getParameter("custName"));
        String guestEmail = safe(request.getParameter("custEmail"));
        String guestPhone = safe(request.getParameter("custPhone"));
        boolean isLocal = "on".equals(request.getParameter("isLocal"))
                || "true".equals(request.getParameter("isLocal"));
        boolean confirmOverlap = "yes".equals(request.getParameter("confirmOverlap"));

        // Server-side validation — never trust client JS alone
        String error = validate(checkInStr, checkOutStr, adultsStr, guestName, guestEmail, guestPhone);
        if (error != null) {
            forwardWithError(request, response, error);
            return;
        }

        Date checkIn = Date.valueOf(checkInStr);
        Date checkOut = Date.valueOf(checkOutStr);
        int adults = Integer.parseInt(adultsStr);
        int children = childrenStr == null || childrenStr.isEmpty() ? 0 : Integer.parseInt(childrenStr);
        int guestAmount = adults + children;

        // Block same user from booking overlapping date ranges (regardless of room).
        // The DB trigger only protects against same-room overlap; this is the per-user rule.
        String userOverlapSql =
                "SELECT reservation_id FROM reservation " +
                "WHERE user_id = ? AND reservation_status = 'confirmed' " +
                "AND ? < reservation_checkOut AND ? > reservation_checkIn " +
                "LIMIT 1";

        String findSql =
                "SELECT room_id, room_price FROM rooms " +
                "WHERE room_status = 'available' AND room_type = ? " +
                "AND room_id NOT IN ( " +
                "    SELECT room_id FROM reservation " +
                "    WHERE reservation_status = 'confirmed' " +
                "    AND ? < reservation_checkOut " +
                "    AND ? > reservation_checkIn " +
                ") LIMIT 1";

        String insertSql =
                "INSERT INTO reservation " +
                "(reservation_guestAmount, reservation_checkIn, reservation_checkOut, " +
                " reservation_status, room_id, user_id) " +
                "VALUES (?, ?, ?, 'confirmed', ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection()) {

            // If user hasn't confirmed yet, warn them about an overlap and let them proceed on purpose.
            if (!confirmOverlap) {
                try (PreparedStatement check = conn.prepareStatement(userOverlapSql)) {
                    check.setInt(1, userId);
                    check.setDate(2, checkIn);
                    check.setDate(3, checkOut);
                    try (ResultSet rs = check.executeQuery()) {
                        if (rs.next()) {
                            int existingId = rs.getInt("reservation_id");
                            request.setAttribute("overlapConfirm",
                                    String.format("You already have reservation MB-%05d for overlapping dates. "
                                            + "Do you want to book another?", existingId));
                            request.setAttribute("existingReservationId", existingId);
                            // Preserve submitted values so the re-rendered form + hidden confirm POST re-send them
                            request.setAttribute("formCheckIn", checkInStr);
                            request.setAttribute("formCheckOut", checkOutStr);
                            request.setAttribute("formRoomType", roomType);
                            request.setAttribute("formAdults", adultsStr);
                            request.setAttribute("formChildren", childrenStr);
                            request.setAttribute("formCustName", guestName);
                            request.setAttribute("formCustEmail", guestEmail);
                            request.setAttribute("formCustPhone", guestPhone);
                            request.setAttribute("formIsLocal", isLocal);
                            request.setAttribute("view", "booking");
                            request.getRequestDispatcher("reservations.jsp").forward(request, response);
                            return;
                        }
                    }
                }
            }

            int roomId;
            BigDecimal roomPrice;

            try (PreparedStatement find = conn.prepareStatement(findSql)) {
                find.setString(1, roomType);
                find.setDate(2, checkIn);
                find.setDate(3, checkOut);
                try (ResultSet rs = find.executeQuery()) {
                    if (!rs.next()) {
                        forwardWithError(request, response,
                                "No " + roomType + " rooms available for those dates. Please try different dates.");
                        return;
                    }
                    roomId = rs.getInt("room_id");
                    roomPrice = rs.getBigDecimal("room_price");
                }
            }

            // Price = nightly rate × number of nights, × 0.85 if local discount
            long nights = ChronoUnit.DAYS.between(
                    LocalDate.parse(checkInStr), LocalDate.parse(checkOutStr));
            if (nights < 1) nights = 1;
            BigDecimal finalPrice = roomPrice.multiply(BigDecimal.valueOf(nights));
            if (isLocal) {
                finalPrice = finalPrice.multiply(new BigDecimal("0.85"));
            }
            finalPrice = finalPrice.setScale(2, RoundingMode.HALF_UP);

            int newId;
            try (PreparedStatement ins = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1, guestAmount);
                ins.setDate(2, checkIn);
                ins.setDate(3, checkOut);
                ins.setInt(4, roomId);
                ins.setInt(5, userId);
                ins.executeUpdate();
                try (ResultSet keys = ins.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new ServletException("Insert succeeded but no reservation_id returned.");
                    }
                    newId = keys.getInt(1);
                }
            }

            // Build the Reservation object for the summary page
            Reservation res = new Reservation();
            res.setReservationId(newId);
            res.setUserId(userId);
            res.setRoomId(roomId);
            res.setRoomType(roomType);
            res.setRoomPrice(roomPrice);
            res.setCheckIn(checkIn);
            res.setCheckOut(checkOut);
            res.setGuestAmount(guestAmount);
            res.setStatus("confirmed");
            res.setGuestName(guestName);
            res.setGuestEmail(guestEmail);
            res.setGuestPhone(guestPhone);
            res.setFinalPrice(finalPrice);
            res.setLocalDiscountApplied(isLocal);

            request.setAttribute("reservation", res);
            request.setAttribute("view", "summary");
            request.getRequestDispatcher("reservations.jsp").forward(request, response);

        } catch (SQLException e) {
            // Trigger on the reservation table blocks double-booking — surface a friendly message
            String msg = e.getMessage() == null ? "" : e.getMessage().toLowerCase();
            if (msg.contains("overlap") || msg.contains("double") || msg.contains("already")) {
                forwardWithError(request, response,
                        "That room is already booked for overlapping dates. Please pick different dates.");
                return;
            }
            throw new ServletException("Something went wrong saving your reservation.", e);
        }
    }

    // GET on this URL should just bounce back to the form
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("reservations.jsp");
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static String validate(String checkIn, String checkOut, String adults,
                                   String name, String email, String phone) {
        if (checkIn == null || checkIn.isEmpty()) return "Check-in date is required.";
        if (checkOut == null || checkOut.isEmpty()) return "Check-out date is required.";
        try {
            if (!Date.valueOf(checkOut).after(Date.valueOf(checkIn))) {
                return "Check-out must be after check-in.";
            }
        } catch (IllegalArgumentException e) {
            return "Invalid date format.";
        }
        int a;
        try { a = Integer.parseInt(adults); } catch (NumberFormatException e) { return "Adults must be a number."; }
        if (a < 1) return "At least 1 adult is required.";
        if (name.isEmpty()) return "Full name is required.";
        if (!EMAIL.matcher(email).matches()) return "Please enter a valid email.";
        if (!PHONE.matcher(phone).matches()) return "Phone format: (555) 555-5555.";
        return null;
    }

    private static void forwardWithError(HttpServletRequest request, HttpServletResponse response,
                                         String error) throws ServletException, IOException {
        request.setAttribute("bookingError", error);
        request.setAttribute("view", "booking");
        request.getRequestDispatcher("reservations.jsp").forward(request, response);
    }
}
