<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Local Attractions - Moffat Bay Resort &amp; Marina</title>

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

        <h2 class="attractions_title">Local Attractions</h2>

        <div class="water_box">

            <h3>Explore Moffat Bay</h3>

            <div style="display:flex; gap:20px; flex-wrap:wrap;">

                <!-- LEFT TEXT LIST -->
                <div style="flex:2; min-width:280px; background:white; padding:20px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">

                    <h3>List of Attractions</h3>

                    <ul class="local_list">
                        <li>Moffat Bay Visitor Center – Information, maps, and exhibits</li>
                        <li>Local Art Shops &amp; Markets – Handmade goods and souvenirs</li>
                        <li>Historical Landmarks – Learn about the area's history</li>
                        <li>Seasonal Festivals &amp; Events – Community events and celebrations</li>
                        <li>Light House – See the ocean over the coast</li>
                    </ul>

                </div>

                <!-- RIGHT IMAGES -->
                <div style="flex:1; min-width:280px; display:flex; flex-direction:column; gap:20px;">

                    <div style="background:white; padding:10px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                        <img src="mbpics/mb_lighthouse.jpg" alt="Lighthouse" style="width:100%; height:180px; object-fit:cover; border-radius:10px;">
                        <p style="text-align:center;">Lighthouse</p>
                    </div>

                    <div style="background:white; padding:10px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                        <img src="mbpics/mb_landmark.jpg" alt="Historical Landmark" style="width:100%; height:180px; object-fit:cover; border-radius:10px;">
                        <p style="text-align:center;">Historical Landmark</p>
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
