<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Moffat Bay - Attractions</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f4f4f4;
        }

        /* HEADER */
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 15px;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .nav_logo img {
            height: 60px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .nav a, .login a {
            color: white;
            margin: 0 10px;
            text-decoration: none;
        }
        
	
        .nav a:hover {
            text-decoration: underline;
        }

        /* LAYOUT */
        .main-container {
            display: flex;
            padding: 20px;
        }

        .content {
            flex: 3;
            background: white;
            padding: 20px;
            margin-right: 20px;
        }

        .sidebar {
            flex: 1;
        }

        .box {
            background: #ddd;
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
        }

        .social {
            background: #5dade2;
            color: white;
        }

        /* HERO SECTION */
        .hero {
            position: relative;
            margin-bottom: 20px;
        }

        .hero-img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .hero-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 28px;
            color: white;
            background: rgba(0,0,0,0.5);
            padding: 15px 25px;
            border-radius: 5px;
        }

        .hero:hover .hero-img {
            filter: brightness(80%);
        }

        /* CATEGORY CARDS */
        .categories {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 20px;
        }

        .category-link {
            width: 30%;
            text-decoration: none;
            color: inherit;
        }

        .category {
            position: relative;
            overflow: hidden;
            border-radius: 5px;
        }

        .category-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .category-text {
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(0,0,0,0.6);
            color: white;
            text-align: center;
            padding: 10px;
        }

        .category:hover .category-img {
            filter: brightness(75%);
        }

        footer {
            text-align: center;
            padding: 10px;
            font-size: 12px;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="header-container">
        <img src="mbpics/mb_logo.jpg" alt="Logo">

        <div class="nav">
            <a href="index.jsp">Home</a>
            <a href="reservations.jsp">Book</a>
            <a href="attractions.jsp">Attractions</a>
            <a href="about.jsp">About Us</a>
            <a href="reservations.jsp">Lodge Reservations</a>
        </div>

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

    </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-container">

    <!-- LEFT SIDE -->
    <div class="content">
        <h1 style="text-align:center;">Attractions</h1>

        <!-- HERO SECTION (FIXED STRUCTURE) -->
        <a href="water.jsp" class="hero-link" style="text-decoration:none;">
            <div class="hero">
                <img src="${pageContext.request.contextPath}/mbpics/Water.jpg"
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
                    <img src="${pageContext.request.contextPath}/mbpics/Outdoor.jpg"
                         class="category-img">
                    <div class="category-text">Outdoor/Nature Attractions</div>
                </div>
            </a>

            <a href="Local.jsp" class="category-link">
                <div class="category">
                    <img src="${pageContext.request.contextPath}/mbpics/Local.jpg"
                         class="category-img">
                    <div class="category-text">Local &amp; Cultural Attractions</div>
                </div>
            </a>

            <a href="Food.jsp" class="category-link">
                <div class="category">
                    <img src="${pageContext.request.contextPath}/mbpics/food.jpg"
                         class="category-img">
                    <div class="category-text">Food Restaurants</div>
                </div>
            </a>

        </div>
    </div>

    <!-- RIGHT SIDE: INFO BOXES -->
    <div class="right-panel">

        <!-- Latest News -->
        <div class="info-box">
            <h2>Latest News</h2>
            <p>Lodge stay sale May 18th to 22nd</p>
            <p>Festival Date June 12th</p>
            <p>First day of Summer June 21st</p>
            <p>Fireworks Display July 4th</p>
        </div>

        <!-- Main Attractions (keeps original + adds new) -->
        <div class="info-box">
            <h2>Main Attractions People Like to Visit</h2>

            <!-- ORIGINAL (keep whatever you had here) -->
            <p>Explore Beaches</p>
            <p>Fishing Tours</p>
            <p>Scuba Diving</p>
            <p>Beach</p>
            <p>Fishing</p>
            <p>Underwater Adventure</p>
        </div>

        <!-- Social Media -->
        <div class="info-box">
            <h2>Moffat Bay Social Media Links</h2>

            <!-- NEW CONTENT -->
            <p><a href="https://x.com/">Twitter Link</a></p>
            <p><a href="https://www.facebook.com/">Facebook Link</a></p>
            <p>Contact Us</p>
            <p>1-555-555-5555</p>
        </div>

    </div>

</div>

<!-- FOOTER -->
<footer>
    Trademarks
</footer>

</body>
</html>