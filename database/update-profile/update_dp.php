<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $image = $_POST['image'];

    if (!$email || !$image) {
        echo json_encode(["success" => false, "message" => "Missing parameters"]);
        exit();
    }

    $imageData = base64_decode($image);

    $stmt = $conn->prepare("UPDATE tbl_account SET dp = ? WHERE email = ?");
    $stmt->bind_param("ss", $imageData, $email);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Profile updated successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Database error"]);
    }

    $stmt->close();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
