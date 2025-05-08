<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

// Get data from the request
$email = $_POST['email'];
$code = $_POST['code'];

// Validate input
if (empty($email) || empty($code)) {
    echo json_encode(['success' => false, 'message' => 'Email and code are required.']);
    exit;
}

$query = "SELECT * FROM password_resets WHERE email = ? AND code = ?";

// Prepare and execute the query
if ($stmt = $conn->prepare($query)) {
    $stmt->bind_param("ss", $email, $code);
    $stmt->execute();
    $result = $stmt->get_result();

    // Check if a matching record was found
    if ($result->num_rows > 0) {
        // Verification code is correct, return success
        echo json_encode(['success' => true, 'message' => 'Code verified.']);
    } else {
        // Code does not match or expired
        echo json_encode(['success' => false, 'message' => 'Invalid code. Please try again.']);
    }

    // Close statement
    $stmt->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to prepare query.']);
}

// Close connection
$conn->close();
