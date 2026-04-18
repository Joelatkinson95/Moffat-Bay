<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="moffatbay.Room" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Rooms - Moffat Bay</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Dancing+Script:wght@600;700&family=Permanent+Marker&display=swap" rel="stylesheet">

    <!-- Link to stylesheet -->
    <link rel="stylesheet" href="mb_stylesheet.css">

</head>
<body>

<!-- Same navigation bar as the landing page -->
<nav>
    <a href="index.html" class="nav_logo">
        <img src="mbpics/mb_logo.jpg" alt="Moffat Bay Resort and Marina Logo">
    </a>

    <ul class="nav_links">
        <li><a href="book.html">Book</a></li>
        <li><a href="about.html">About Us</a></li>
        <li><a href="contact.html">Contact Us</a></li>
        <li><a href="attractions.html">Attractions</a></li>
        <li><a href="reservations.html">Reservations</a></li>
    </ul>

    <div class="nav_auth">
        <a href="login.html" class="nav_login">Log In</a>
        <a href="signup.html" class="nav_signup">Sign Up</a>
    </div>
</nav>


<!-- Results section -->
<section class="results_section">

    <h1 class="results_heading">Available Rooms</h1>

    <!-- Show what the user searched for -->
    <div class="search_summary">
        <strong>Check In:</strong> ${checkIn} &nbsp;|&nbsp;
        <strong>Check Out:</strong> ${checkOut} &nbsp;|&nbsp;
        <strong>Rooms:</strong> ${rooms} &nbsp;|&nbsp;
        <strong>Guests:</strong> ${totalGuests} (${adults} adults, ${children} children)
    </div>

    <%
        // Pull the list of available room types from the servlet
        List<Room> typeList = (List<Room>) request.getAttribute("availableTypes");

        if (typeList != null && !typeList.isEmpty()) {
    %>
        <table class="rooms_table">
            <tr>
                <th>Room Type</th>
                <th>Price per Night</th>
                <th>Reserve</th>
            </tr>
            <% for (Room r : typeList) { %>
                <tr>
                    <td><%= r.getRoomType() %></td>
                    <td>$<%= r.getRoomPrice() %></td>
                    <td>
                        <!-- Send the room TYPE and dates to the reservations page -->
                        <a class="book_link"
                           href="reservations.html?roomType=<%= r.getRoomType() %>&checkIn=${checkIn}&checkOut=${checkOut}&guests=${totalGuests}">
                            Book Now
                        </a>
                    </td>
                </tr>
            <% } %>
        </table>
    <% } else { %>
        <div class="no_rooms">
            <p>Sorry, no rooms are available for those dates.</p>
            <p>Please <a href="index.html">go back</a> and try different dates.</p>
        </div>
    <% } %>

</section>

</body>
</html>