<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'];
    $message = $_POST['message'];

    $stmt = $conn->prepare("INSERT INTO logs (name, message) VALUES (?, ?)");
    $stmt->bind_param("ss", $name, $message);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Log saved successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to save log"]);
    }

    $stmt->close();
    $conn->close();
}
