<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Database connection failed."]);
    exit();
}

$sql = "SELECT timestamp, name, message FROM logs ORDER BY timestamp DESC";
$result = $conn->query($sql);

$logs = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $logs[] = [
            "timestamp" => $row["timestamp"],
            "name" => $row["name"],
            "message" => $row["message"]
        ];
    }

    echo json_encode([
        "success" => true,
        "data" => $logs
    ]);
} else {
    echo json_encode([
        "success" => true,
        "data" => []
    ]);
}

$conn->close();
