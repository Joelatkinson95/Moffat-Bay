<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants - Moffat Bay Resort &amp; Marina</title>

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

        .nav_links li a {
            color: white;
            text-decoration: none;
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

        /* ================= MAIN BOX ================= */
        .main_box {
            background: #eef6fb;
            padding: 30px;
            border-radius: 15px;
            border: 2px solid #d0dbe5;
        }

        .page_title {
            font-size: 32px;
            margin-bottom: 20px;
        }
        
        /* ================= RESTAURANT LIST ================= */
		.nature_list li {
    		font-size: 20px;
    		font-weight: 600;
		}

		.nature_list p {
    		font-size: 16px;
    		margin-left: 10px;
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

    <!-- ================= LEFT SIDE ================= -->
    <div class="left_content">

        <h2 class="page_title">Wilderness Attractions</h2>

        <div class="main_box">

            <div style="display:flex; gap:20px; flex-wrap:wrap;">

                <!-- LEFT LIST -->
                <div style="flex:2; min-width:280px; background:white; padding:20px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">

                    <h3>List of Attractions</h3>

                    <ul class="nature_list">
                        <li> Moffat Bay Hiking Trails </li>
                        <p> Scenic trails for all skill levels with views of forests and coast line. </p>
                        <p> Look at the old historic coast building that is over 100 years old.</p> 

                        <li>Wildlife Viewing Areas</li>
                        <p> Spot birds, deer, and marine life. </p>

                        <li>Sunset Beach</li>
                        <p>Ideal for relaxing,  </p>
                        <p>swimming, </p>
                        <p>and photography. </p>
                        
                        <li> Snorkeling  </li>
                        <p> get up close with the ocean wild life </p>
                    </ul>

                </div>

                <!-- RIGHT IMAGES --> 
                <div style="flex:1; min-width:280px; display:flex; flex-direction:column; gap:20px;">

                    <div style="background:white; padding:10px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                        <img src="mbpics/Trail.jpg" alt="Trail" style="width:100%; height:280px; object-fit:cover; border-radius:10px;">
                        <p style="text-align:center;">Picture of a trail</p>
                    </div>

                    <div style="background:white; padding:10px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                        <img src="mbpics/Map.jpg" alt="Map" style="width:100%; height:280px; object-fit:cover; border-radius:10px;">
                        <p style="text-align:center;">map of a wilderness route</p>
                    </div>

                </div>

            </div>

            <!-- BOTTOM FEATURE BOX -->
            <div style="margin-top:20px; background:white; padding:20px; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.1); text-align:center;">

                <h3>Other Information </h3>
                <p>Tour Guides.</p>
                <p>Bike Rental locations.</p>
                <p>Upcoming Tour Guides</p>

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
            <h3>Main Attraction People Like to Visit</h3>
            <p>Waterfront Dining</p>
            <p>Local Cafés</p>
            <p>Seafood Specials</p>
            <p>Ice Cream Stands</p>
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