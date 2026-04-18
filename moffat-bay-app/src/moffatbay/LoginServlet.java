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

/* Handles user login from login.jsp.
   Checks email and password against the users table
   and creates a session if they match. */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the form values
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password");

        // Look up the user by email
        String sql = "SELECT * FROM users WHERE user_email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Found the user, now check the password
                String storedPassword = rs.getString("user_password");

                if (storedPassword.equals(password)) {
                    // Password matches, create a session for the user
                    HttpSession session = request.getSession();
                    session.setAttribute("user_id", rs.getInt("user_id"));
                    session.setAttribute("email", rs.getString("user_email"));
                    session.setAttribute("firstName", rs.getString("user_firstName"));

                    // Send them to the home page
                    response.sendRedirect("index.html");
                } else {
                    // Wrong password
                    request.setAttribute("error", "Invalid password. Please try again.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // No user found with that email
                request.setAttribute("error", "No account found with that email.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Something went wrong during login.", e);
        }
    }
}