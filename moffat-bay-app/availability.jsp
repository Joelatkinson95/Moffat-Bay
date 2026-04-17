OK<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
    <link rel="stylesheet" href="../src/moffatbay/mb_stylesheet.css">

    <!-- A few simple styles just for this page -->
    <style>
        .results_section {
            padding: 6rem 2rem 3rem;
            max-width: 960px;
            margin: 0 auto;
        }
        .results_heading {
            color: var(--sea_blue);
            margin-bottom: 1rem;
        }
        .search_summary {
            background: var(--off_white);
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 2rem;
        }
        .rooms_table {
            width: 100%;
            border-collapse: collapse;
        }
        .rooms_table th,
        .rooms_table td {
            padding: 0.8rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .rooms_table th {
            background: var(--sea_blue);
            color: var(--white);
        }
        .book_link {
            background: var(--deep_sea_green);
            color: var(--white);
            padding: 0.4rem 0.8rem;
            text-decoration: none;
            border-radius: 4px;
        }
        .book_link:hover {
            background: var(--sea_green_dark);
        }
        .no_rooms {
            text-align: center;
            padding: 2rem;
            color: var(--text_dark);
        }
    </style>
</head>
<body>

<!-- Same navigation bar as the landing page -->
<nav>
    <a href="../src/moffatbay/index.html" class="nav_logo">
        <img src="../mbpics/mb_logo.jpg" alt="Moffat Bay Resort and Marina Logo">
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
        // Pull the list of rooms the servlet put in the request
        List<Room> roomList = (List<Room>) request.getAttribute("availableRooms");

        if (roomList != null && !roomList.isEmpty()) {
    %>
        <table class="rooms_table">
            <tr>
                <th>Room</th>
                <th>Type</th>
                <th>Price per Night</th>
                <th>Reserve</th>
            </tr>
            <% for (Room r : roomList) { %>
                <tr>
                    <td><%= r.getRoomId() %></td>
                    <td><%= r.getRoomType() %></td>
                    <td>$<%= r.getRoomPrice() %></td>
                    <td>
                        <!-- Send user to the reservations page with the picked room and dates -->
                        <a class="book_link"
                           href="reservations.html?roomId=<%= r.getRoomId() %>&checkIn=${checkIn}&checkOut=${checkOut}">
                            Book This Room
                        </a>
                    </td>
                </tr>
            <% } %>
        </table>
    <% } else { %>
        <div class="no_rooms">
            <p>Sorry, no rooms are available for those dates.</p>
            <p>Please <a href="../src/moffatbay/index.html">go back</a> and try different dates.</p>
        </div>
    <% } %>

</section>

</body>
</html>