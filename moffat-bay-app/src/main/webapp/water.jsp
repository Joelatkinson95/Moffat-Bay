<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attractions - Moffat Bay Resort &amp; Marina</title>

    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>

        /* ================= NAV ================= */
        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 30px;
            background: #0b2a3a;
            font-family: 'Montserrat', sans-serif;
        }

        .nav_logo img {
            height: 60px;
        }

        .nav_links {
            list-style: none;
            display: flex;
            gap: 20px;
        }

        .nav_links li a,
        .nav_auth a {
            color: white;
            text-decoration: none;
            margin-left: 10px;
        }

        body {
            margin: 0;
            font-family: 'Montserrat', sans-serif;
            background: #f5f7fa;
        }

        /* ================= PAGE LAYOUT ================= */
        .page_container {
            display: flex;
            gap: 25px;
            padding: 40px;
        }

        .left_content {
            flex: 3;
        }

        .right_sidebar {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .sidebar_box {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        /* ================= TITLE ================= */
        .attractions_title {
            font-size: 32px;
            margin-bottom: 20px;
        }

        .water_box {
            background: #eef6fb;
            padding: 30px;
            border-radius: 15px;
        }

        .water_title {
            font-size: 24px;
            margin-bottom: 25px;
        }

        /* ================= TOP SECTION (IMAGE + TEXT) ================= */
        .water_top {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .water_image {
            flex: 1;
            min-width: 280px;
        }

        .water_image img {
            width: 100%;
            height: 350px;
            object-fit: cover;
            border-radius: 12px;
        }

        .water_text {
            flex: 1;
            min-width: 280px;
            font-size: 16px;
            line-height: 1.6;
            color: #333;
        }

        /* ================= BOTTOM SECTION (FISHING + SWIMMING) ================= */
        .water_bottom {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .water_card {
            flex: 1;
            min-width: 280px;
            border-radius: 15px;
            overflow: hidden;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }

        .water_card img {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }

        .water_card_text {
            padding: 15px;
        }

    </style>
</head>

<body>

<!-- ================= NAV ================= -->
<nav>
    <a href="index.jsp" class="nav_logo">
        <img src="mbpics/mb_logo.jpg" alt="Logo">
    </a>

    <ul class="nav_links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="reservations.jsp">Book</a></li>
        <li><a href="attractions.jsp">Attractions</a></li>
        <li><a href="about.jsp">About Us</a></li>
        <li><a href="reservations.jsp">Lodge Reservations</a></li>
    </ul>

    <div class="login">
        <% if (session.getAttribute("firstName") != null) { %>
        	<span style="color:white;">
        		Welcome, <%= session.getAttribute("firstName") %> <%= session.getAttribute("lastName") %>
            </span>       
            |    
            <a href="LogoutServlet" style="color:white;">Log Out</a>          
        <% } else { %>
            <a href="login.jsp" style="color:white;">Log In</a>
            |
            <a href="signup.jsp" style="color:white;">Sign Up</a>
            <% } %>
    </div>
</nav>

<!-- ================= PAGE CONTENT ================= -->
<div class="page_container">

    <!-- LEFT SIDE -->
    <div class="left_content">

        <h2 class="attractions_title">List of Attractions</h2>

        <div class="water_box">

            <h3 class="water_title">Water Attractions</h3>

            <!-- ================= TOP SECTION ================= -->
            <div class="water_top">

                <div class="water_image">
                    <img src="mbpics/Water.jpg" alt="Water View">
                </div>

                <div class="water_text">
                    Come experience our water relaxation with fishing, calm swimming in our beach, or 
                    simply unwind in the quiet luxury of island life.
					<p>Kayaking through the morning waters<p> 
					<p>Even  spot orcas from the shoreline or Whales on our special whale watching trip.<p>  
                </div>

            </div>

            <!-- ================= BOTTOM SECTION ================= -->
            <div class="water_bottom">

                <!-- FISHING -->
                <div class="water_card">
                    <img src="mbpics/Fishing.jpg" alt="Fishing">
                    <div class="water_card_text">
                        <h4>Fishing</h4>
                        <p>World-class salmon, halibut, and trout fishing right off the coast.</p>
                    </div>
                </div>

                <!-- SWIMMING -->
                <div class="water_card">
                    <img src="mbpics/Swim.jpg" alt="Swimming">
                    <div class="water_card_text">
                        <h4>Swimming</h4>
                        <p>Calm, clean waters perfect for swimming and shoreline relaxation.</p>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- ================= RIGHT SIDEBAR ================= -->
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
            <p><a href="https://x.com/">Twitter Link</a></p>
            <p><a href="https://www.facebook.com/">Facebook Link</a></p>
            <p>Contact Us</p>
            <p>1-555-555-5555</p>
        </div>

    </div>

</div>

</body>
</html>