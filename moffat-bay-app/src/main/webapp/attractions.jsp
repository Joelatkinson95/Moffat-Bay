<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay - Attractions</title>

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

<!-- MAIN CONTENT -->
<div class="main-container">

    <!-- LEFT SIDE -->
    <div class="content">
        <h1>Attractions</h1>

        <!-- HERO SECTION -->
        <a href="water.jsp" class="hero-link">
            <div class="hero">
                <img src="${pageContext.request.contextPath}/mbpics/mb_bay.jpg"
                     alt="Water Attractions"
                     class="hero-img">

                <div class="hero-text">
                    Water Attractions <br>
                    (Main Attractions in the Bay)
                </div>
            </div>
        </a>

        <!-- CATEGORY SECTIONS -->
        <div class="categories">

            <a href="Nature.jsp" class="category-link">
                <div class="category">
                    <img src="${pageContext.request.contextPath}/mbpics/mb_outdoor.jpg"
                         alt="Outdoor and Nature Attractions"
                         class="category-img">
                    <div class="category-text">Outdoor/Nature Attractions</div>
                </div>
            </a>

            <a href="Local.jsp" class="category-link">
                <div class="category">
                    <img src="${pageContext.request.contextPath}/mbpics/mb_local.jpg"
                         alt="Local and Cultural Attractions"
                         class="category-img">
                    <div class="category-text">Local &amp; Cultural Attractions</div>
                </div>
            </a>

            <a href="Food.jsp" class="category-link">
                <div class="category">
                    <img src="${pageContext.request.contextPath}/mbpics/mb_dining.jpg"
                         alt="Food Restaurants"
                         class="category-img">
                    <div class="category-text">Food Restaurants</div>
                </div>
            </a>

        </div>
    </div>

    <!-- RIGHT SIDE: INFO BOXES -->
    <div class="right-panel">

        <div class="info-box">
            <h2>Latest News</h2>
            <p>Lodge stay sale May 18th to 22nd</p>
            <p>Festival Date June 12th</p>
            <p>First day of Summer June 21st</p>
            <p>Fireworks Display July 4th</p>
        </div>

        <div class="info-box">
            <h2>Main Attractions People Like to Visit</h2>
            <p>Explore Beaches</p>
            <p>Fishing Tours</p>
            <p>Scuba Diving</p>
            <p>Beach</p>
            <p>Fishing</p>
            <p>Underwater Adventure</p>
        </div>

        <div class="info-box">
            <h2>Moffat Bay Social Media Links</h2>
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
