<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Fetch backups
$sql = "SELECT id, backup_file_name, backup_date FROM tbl_backups ORDER BY id DESC";
$result = $conn->query($sql);

$backups = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $backups[] = $row;
    }
}

// Output JSON
echo json_encode($backups);

// Close connection
$conn->close();
