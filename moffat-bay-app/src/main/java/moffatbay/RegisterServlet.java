package moffatbay;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/* Handles user registration from signup.jsp.
   Checks if the email is already taken, then inserts the new user. */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the form values
        String firstName = request.getParameter("firstName").trim();
        String lastName = request.getParameter("lastName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String password = request.getParameter("password");

        // Check if the email is already in the database
        String checkSql = "SELECT user_id FROM users WHERE user_email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Email already exists, send user back with error
                request.setAttribute("error", "That email is already registered.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            // Email is available, insert the new user
            String insertSql = "INSERT INTO users " +
                    "(user_email, user_password, user_firstName, user_lastName, user_phoneNumber) " +
                    "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, email);
            insertStmt.setString(2, password);
            insertStmt.setString(3, firstName);
            insertStmt.setString(4, lastName);
            insertStmt.setString(5, phone);
            insertStmt.execute();

            // Registration worked, send to login page with success message
            request.setAttribute("success", "Account created! You can now log in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Something went wrong during registration.", e);
        }
    }
}