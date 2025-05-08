<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

if (!isset($_POST['email'], $_POST['code'])) {
    echo json_encode(["error" => "Email and code are required"]);
    exit;
}

$email = $_POST['email'];
$code = $_POST['code'];

$sql = "SELECT code, expires_at FROM verification_code WHERE email = ? ORDER BY expires_at DESC LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["error" => "No verification code found for this email"]);
    exit;
}

$row = $result->fetch_assoc();
$db_code = $row['code'];
$expires_at = $row['expires_at'];

if ($db_code !== $code) {
    echo json_encode(["error" => "Invalid verification code"]);
} elseif (strtotime($expires_at) < time()) {
    echo json_encode(["error" => "Verification code has expired"]);
} else {
    echo json_encode(["success" => "Verification successful"]);
}

$conn->close();
