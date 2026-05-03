<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Water Attractions - Moffat Bay Resort &amp; Marina</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Dancing+Script:wght@600;700&family=Permanent+Marker&display=swap" rel="stylesheet">

    <!-- Shared site stylesheet (nav + attraction-page styles) -->
    <link rel="stylesheet" href="mb_stylesheet.css">

    <!-- Font Awesome (for social media icons) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<!-- Shared nav -->
<nav>
    <a href="index.jsp" class="nav_logo">
        <img src="mbpics/mb_logo.jpg" alt="Moffat Bay Resort and Marina Logo">
    </a>

    <ul class="nav_links">
        <li><a href="reservations.jsp">Book</a></li>
        <li><a href="about.jsp">About Us</a></li>
        <li><a href="attractions.jsp">Attractions</a></li>
        <li><a href="reservations.jsp?view=lookup">Reservations</a></li>
    </ul>

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

<!-- PAGE CONTENT -->
<div class="page_container">

    <!-- LEFT SIDE -->
    <div class="left_content">

        <h2 class="attractions_title">List of Attractions</h2>

        <div class="water_box">

            <h3 class="water_title">Water Attractions</h3>

            <!-- TOP SECTION (image + text) -->
            <div class="water_top">

                <div class="water_image">
                    <img src="mbpics/mb_kayak.jpg" alt="Water View">
                </div>

                <div class="water_text">
                    Come experience our water relaxation with fishing, calm swimming in our beach, or
                    simply unwind in the quiet luxury of island life.
                    <p>Kayaking through the morning waters</p>
                    <p>Even spot orcas from the shoreline or Whales on our special whale watching trip.</p>
                </div>

            </div>

            <!-- BOTTOM SECTION (Fishing + Swimming cards) -->
            <div class="water_bottom">

                <!-- FISHING -->
                <div class="water_card">
                    <img src="mbpics/mb_fishing.jpg" alt="Fishing">
                    <div class="water_card_text">
                        <h4>Fishing</h4>
                        <p>World-class salmon, halibut, and trout fishing right off the coast.</p>
                    </div>
                </div>

                <!-- SWIMMING -->
                <div class="water_card">
                    <img src="mbpics/mb_swimming.jpg" alt="Swimming">
                    <div class="water_card_text">
                        <h4>Swimming</h4>
                        <p>Calm, clean waters perfect for swimming and shoreline relaxation.</p>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- RIGHT SIDEBAR -->
    <div class="right_sidebar">

        <div class="sidebar_box">
            <h3>Latest News</h3>
            <p>Lodge stay sale May 18th to 22nd</p>
            <p>Festival Date June 12th</p>
            <p>First day of Summer June 21st</p>
            <p>Fireworks Display July 4th</p>
        </div>

        <div class="sidebar_box">
            <h3>Main Attractions People Like to Visit</h3>
            <p>Explore Beaches</p>
            <p>Fishing Tours</p>
            <p>Scuba Diving</p>
            <p>Beach</p>
            <p>Fishing</p>
            <p>Underwater Adventure</p>
        </div>

        <div class="sidebar_box">
            <h3>Moffat Bay Social Media Links</h3>
            <p><a href="about.jsp">Contact Us</a></p>
            <div class="social_icons_row">
                <a href="https://x.com/" target="_blank" aria-label="Twitter"><i class="fa-brands fa-x-twitter"></i></a>
                <a href="https://www.facebook.com/" target="_blank" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
            </div>
            <p>1-555-555-5555</p>
        </div>

    </div>

</div>

<!-- Site footer -->
<footer class="site_footer">
    <div class="site_footer_inner">
        <p class="site_footer_text">
            &copy; 2026 Moffat Bay Resort &amp; Marina. All rights reserved. Joviedsa Island, PNW.
        </p>
    </div>
</footer>

</body>
</html>
