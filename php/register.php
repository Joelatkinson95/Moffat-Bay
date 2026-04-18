<?php
include 'db.php';

$firstName = trim($_POST['firstName']);
$lastName = trim($_POST['lastName']);
$email = trim($_POST['email']);
$phone = trim($_POST['phone']);
$password = $_POST['password'];

// hash password (important even if DB sample doesn't)
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// check if email already exists
$sql = "SELECT user_id FROM users WHERE user_email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo "Email already registered";
    exit();
}

// insert user
$sql = "INSERT INTO users 
(user_email, user_password, user_firstName, user_lastName, user_phoneNumber)
VALUES (?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssss", $email, $hashedPassword, $firstName, $lastName, $phone);

if ($stmt->execute()) {
    echo "Registration successful";
} else {
    echo "Error occurred: " . $conn->error;
}
?>