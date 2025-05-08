<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$email = $_POST['email'];
$new_password = $_POST['password'];

// Validate input
if (empty($email) || empty($new_password)) {
    echo json_encode(['success' => false, 'message' => 'Email and password are required.']);
    exit;
}

// Do NOT hash the password (plaintext)
$query = "UPDATE tbl_account SET password = ? WHERE email = ?";

// Prepare and execute the query
if ($stmt = $conn->prepare($query)) {
    $stmt->bind_param("ss", $new_password, $email);  // Both are strings
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode(['success' => true, 'message' => 'Password reset successfully.']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to reset password.']);
    }

    $stmt->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare query.']);
}

$conn->close();
