<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Resort & Marina</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Dancing+Script:wght@600;700&family=Permanent+Marker&display=swap" rel="stylesheet">

    <!-- Link to stylesheet -->
    <link rel="stylesheet" href="mb_stylesheet.css">
</head>
<body>

<!-- Navigation bar at top of page -->
<nav>
    <a href="index.jsp" class="nav_logo">
        <img src="mbpics/mb_logo.jpg" alt="Moffat Bay Resort and Marina Logo">
    </a>

    <!-- Main menu links -->
    <ul class="nav_links">
        <li><a href="reservations.jsp">Book</a></li>
        <li><a href="about.html">About Us</a></li>
        <li><a href="attractions.html">Attractions</a></li>
        <li><a href="reservations.jsp?view=lookup">Reservations</a></li>
    </ul>

    <!-- Show welcome message if logged in, otherwise show login/signup -->
    <div class="nav_auth">
        <% if (session.getAttribute("firstName") != null) { %>
            <span class="nav_welcome">Welcome, <%= session.getAttribute("firstName") %> <%= session.getAttribute("lastName") %></span>
            <a href="LogoutServlet" class="nav_login">Log Out</a>
        <% } else { %>
            <a href="login.jsp" class="nav_login">Log In</a>
            <a href="signup.jsp" class="nav_signup">Sign Up</a>
        <% } %>
    </div>
</nav>


<!-- Hero section with background picture and booking form -->
<section class="hero">
    <img src="mbpics/mb_whale.jpg" alt="Pacific Northwest coastline with orca whale" class="hero_img">
    <div class="hero_overlay"></div>

    <!-- Main headline over the picture -->
    <div class="hero_text">
        <h1 class="hero_heading">
            Explore Everything the<br>
            Pacific Northwest Has to Offer
        </h1>
        <p class="hero_sub">We'll Handle the Rest!</p>
    </div>

    <!-- Booking form -->
    <form class="booking_bar" action="CheckAvailabilityServlet" method="GET">

        <div class="booking_field">
            <label for="checkIn">Check In</label>
            <input type="date" id="checkIn" name="checkIn" required>
        </div>

        <div class="booking_field">
            <label for="checkOut">Check Out</label>
            <input type="date" id="checkOut" name="checkOut" required>
        </div>

        <div class="booking_field booking_field_small">
            <label for="rooms">Rooms</label>
            <select id="rooms" name="rooms">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
            </select>
        </div>

        <div class="booking_field booking_field_small">
            <label for="adults">Adults</label>
            <select id="adults" name="adults">
                <option value="1">1</option>
                <option value="2" selected>2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
            </select>
        </div>

        <div class="booking_field booking_field_small">
            <label for="children">Children</label>
            <select id="children" name="children">
                <option value="0" selected>0</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
            </select>
        </div>

        <button type="submit" class="check_btn">Check Availability</button>

    </form>
</section>


<!-- Welcome section below the picture -->
<section class="welcome_section">

    <h2 class="welcome_heading">
        Welcome to the Moffat Bay Resort Lodge, Joviedsa Island
    </h2>

    <!-- Blue card with info and lodge picture -->
    <div class="welcome_card">
        <div class="welcome_card_text">
            <p class="welcome_tagline">
                Escape to the last untouched corner of the PNW...
            </p>
            <p class="welcome_body">
                Nestled on the shores of Joviedsa Island in Washington's breathtaking
                San Juan Islands, Moffat Bay Lodge offers a one of a kind retreat where
                old-growth forest meets the open sea. Whether you're here to kayak through
                glassy morning waters, spot orcas from the shoreline, or simply unwind in
                the quiet luxury of island life, Moffat Bay is your gateway to the Pacific
                Northwest at its most pure and undisturbed.
            </p>
        </div>
        <img src="mbpics/mb_lodge.jpg" alt="Moffat Bay Lodge exterior" class="welcome_img">
    </div>

</section>

</body>
</html>
