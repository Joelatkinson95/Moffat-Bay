<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Moffat Bay</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Font Awesome for social media icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="mb_stylesheet.css">
    <link rel="stylesheet" href="auth_styles.css">
</head>
<body>

<!-- Navigation bar -->
<nav>
    <a href="index.html" class="nav_logo">
        <img src="mbpics/mb_logo.jpg" alt="Moffat Bay Resort and Marina Logo">
    </a>

    <ul class="nav_links">
        <li><a href="book.html">Book</a></li>
        <li><a href="about.html">About Us</a></li>
        <li><a href="attractions.html">Attractions</a></li>
        <li><a href="reservations.html">Reservations</a></li>
    </ul>

    <div class="nav_auth">
        <a href="login.jsp" class="nav_login">Log In</a>
        <a href="signup.jsp" class="nav_signup">Sign Up</a>
    </div>
</nav>


<!-- Split page layout -->
<section class="auth_page">

    <!-- Left side -->
    <div class="auth_left">

        <!-- Top section with resort name -->
        <div class="auth_left_top">
            <h1 class="brand_name">Moffat Bay</h1>
            <p class="brand_sub">Resort & Marina</p>
        </div>

        <!-- Bottom section with description and social links -->
        <div class="auth_left_bottom">
            <h2 class="left_heading">Say Hello to Nature</h2>
            <p class="left_description">
                Moffat Bay is a serene coastal destination offering scenic views,
                relaxing stays, outdoor activities, and unforgettable waterfront
                experiences for visitors.
            </p>
            <p class="social_label">Please visit our social media</p>
            <div class="social_icons">
                <a href="https://www.instagram.com" target="_blank" class="social_link">
                    <i class="fa-brands fa-instagram"></i>
                </a>
                <a href="https://www.facebook.com" target="_blank" class="social_link">
                    <i class="fa-brands fa-facebook-f"></i>
                </a>
                <a href="https://www.x.com" target="_blank" class="social_link">
                    <i class="fa-brands fa-x-twitter"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Right side with signup form -->
    <div class="auth_right">

        <h1 class="auth_heading">Sign Up</h1>
        <p class="auth_subtext">
            Already have an account?
            <a href="login.jsp" class="create_link">Log in here</a>
        </p>

        <!-- Show error message if registration failed -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="auth_error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="RegisterServlet" method="POST">
            <!-- First name and last name side by side -->
            <div class="auth_row">
                <div class="auth_field">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" placeholder="First name" required>
                </div>
                <div class="auth_field">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" placeholder="Last name" required>
                </div>
            </div>

            <div class="auth_field">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="auth_field">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" placeholder="555-123-4567" required>
            </div>

            <div class="auth_field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Create a password" required>
            </div>

            <div class="auth_field">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
            </div>

            <button type="submit" class="auth_btn">Sign Up</button>
        </form>

        <p class="auth_bottom">
            Already a member? <a href="login.jsp">Log in</a>
        </p>
    </div>

</section>

</body>
</html>
