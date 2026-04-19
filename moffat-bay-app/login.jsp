<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log In - Moffat Bay</title>

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
    <a href="index.jsp" class="nav_logo">
        <img src="mbpics/mb_logo.jpg" alt="Moffat Bay Resort and Marina Logo">
    </a>

    <ul class="nav_links">
        <li><a href="book.html">Book</a></li>
        <li><a href="about.html">About Us</a></li>
        <li><a href="attractions.html">Attractions</a></li>
        <li><a href="reservations.html">Reservations</a></li>
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

    <!-- Right side with login form -->
    <div class="auth_right">

        <h1 class="auth_heading">Login</h1>
        <p class="auth_subtext">
            Don't have an account?
            <a href="signup.jsp" class="create_link">Create your account</a>
        </p>

        <!-- Show error message if login failed -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="auth_error"><%= request.getAttribute("error") %></div>
        <% } %>

        <!-- Show success message after registration -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="auth_success"><%= request.getAttribute("success") %></div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <div class="auth_field">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="auth_field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>

            <!-- Remember me and forgot password row -->
            <div class="auth_options">
                <label class="remember_me">
                    <input type="checkbox" name="remember"> Remember me
                </label>
                <a href="#" class="forgot_link">Forgot password?</a>
            </div>

            <button type="submit" class="auth_btn">Log In</button>
        </form>

        <p class="auth_bottom">
            New User? <a href="signup.jsp">Sign up</a>
        </p>
    </div>

</section>

</body>
</html>
