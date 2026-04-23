<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Moffat Bay Resort - About Us</title>

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Dancing+Script:wght@600;700&family=Permanent+Marker&display=swap" rel="stylesheet">

        <!-- Link to stylesheet -->
        <link rel="stylesheet" href="mb_stylesheet.css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/about.css">
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
                <li><a href="about.jsp">About Us</a></li>
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

        <section class="about-section">
            <div class="about-intro">
                <h2>About Us</h2>
                <div class="section-divider"></div>

                <div class="mission-statement">
                    <p>
                        At Moffat Bay Lodge, our mission is to provide professional service and 
                        exceptional quality, creating unforgettable travel experiences for families 
                        and business travelers alike. We strive to be a welcoming community where 
                        relaxation and new adventures come together, ensuring each guest feels at 
                        home while exploring the beauty of our surroundings.
                    </p>
                </div>
            </div>
            <div class="about-content">
                <div class="about-visuals">
                    <div class="image-area">
                        <img src="mbpics/mb_lodge.jpg" alt="Moffat Bay Lodge">
                    </div>

                    <div class="stats-row">
                        <div class="stat-box">
                            <span class="stat-highlight">5M</span>
                            <p class="stat-label">Customers Served</p>
                        </div>

                        <div class="stat-box">
                            <span class="stat-highlight">7</span>
                            <p class="stat-label">Locations</p>
                        </div>

                        <div class="stat-box">
                            <span class="stat-highlight">3.5M</span>
                            <p class="stat-label">Positive Reviews</p>
                        </div>
                    </div>
                </div>

                <div class="our-story">
                    <h2>Our Story</h2>
                    <div class="section-divider"></div>

                    <div class="story-content">
                        <p>
                            Moffat Bay Lodge began as a simple vision rooted in a deep appreciation 
                            for the natural beauty and quiet charm of the surrounding landscape. What 
                            started as a modest retreat for weary travelers has grown into a destination 
                            where comfort, connection, and discovery are thoughtfully woven together. 
                            From the very beginning, the founders believed that a stay should be more 
                            than just a place to rest—it should be an experience that lingers long after 
                            guests have returned home.
                        </p>
                        <p>
                            In its early days, the lodge welcomed a small number of visitors—families 
                            seeking a peaceful escape, and professionals looking for a place to recharge 
                            between journeys. Word quickly spread about the warmth of the hospitality and 
                            the care placed into every detail, from the quality of the accommodations to 
                            the personalized service each guest received. Over time, Moffat Bay Lodge evolved, 
                            expanding its offerings while staying true to its original purpose: to create a 
                            space where people could feel both at ease and inspired.
                        </p>
                        <p>
                            As the lodge grew, so did its connection to the community and environment around it. 
                            Local partnerships were formed, traditions were established, and the lodge became 
                            a gateway for guests to explore the region’s unique character. Whether it’s a quiet 
                            morning overlooking the water or an afternoon filled with new adventures, each moment 
                            at Moffat Bay is designed to bring people closer to both nature and one another.
                        </p>
                        <p>
                            Today, Moffat Bay Lodge stands as a reflection of its journey—a place shaped by years of 
                            dedication, meaningful experiences, and a commitment to excellence. While much has changed 
                            since its founding, the heart of the lodge remains the same: a welcoming haven where every 
                            guest is treated like family, and every visit becomes a story worth sharing.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact-section">
            <div class="contact-info">
                <h2>Contact Us</h2>
                <div class="section-divider"></div>
                
                <p>
                    Have a question, planning your next stay, or just looking for more information? 
                    We’re here to help. Whether you’re organizing a family getaway or a business 
                    retreat, our team is ready to make your experience at Moffat Bay Lodge seamless 
                    and enjoyable. Reach out to us anytime—we look forward to hearing from you.
                </p>

                <h3>Core values</h3>

                <ul>
                    <li>Hospitality First</li>
                    <li>Quality in Every Detail</li>
                    <li>Connection & Community</li>
                    <li>Adventure & Relaxation</li>
                    <li>Integrity & Trust</li>
                </ul>
            </div>

            <div class="contact-form">
                <form method="POST">
                    <div class="form-names">
                        <div>
                            <label for="firstName">First Name</label><br>
                            <input type="text" id="firstName"><br>
                        </div>

                        <div>
                            <label for="lastName">Last Name</label><br>
                            <input type="text" id="lastName"><br>
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <label for="email">Email</label><br>
                        <input type="text" id="email"><br>
                    </div>

                    <div class="form-section">
                        <label for="message">Message</label><br>
                        <textarea name="message" id="message" class="message-box" wrap="soft"></textarea>
                    </div>
                    
                    <button type="submit">Submit</button>
                </form>
            </div>
        </section>
    </body>
</html>
