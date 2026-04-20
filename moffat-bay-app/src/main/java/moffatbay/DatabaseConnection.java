package moffatbay;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/* Helper class for connecting to the Moffat Bay database.
   Other students can call DatabaseConnection.getConnection() from any servlet. */
public class DatabaseConnection {

    // Database info pulled from mblodge_final.sql
    private static final String URL = "jdbc:mysql://localhost:3306/mblodge";
    private static final String USER = "mbGuest123";
    private static final String PASSWORD = "mbPass123!";

    // Returns a new connection to the database
    public static Connection getConnection() throws SQLException {
        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL driver not found. Make sure the connector jar is in WEB-INF/lib.", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}