<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

// Check if campus parameter is provided
if (!isset($_GET['campus'])) {
    echo json_encode(["error" => "Campus parameter is missing."]);
    exit;
}

$campus = $conn->real_escape_string($_GET['campus']);
$division = isset($_GET['division']) ? $conn->real_escape_string($_GET['division']) : null;

// Query based on division parameter
if ($division) {
    // If division is provided, filter by both campus and division and order alphabetically by office
    $sql = "SELECT office FROM tbl_office WHERE campus = '$campus' AND division = '$division' ORDER BY office ASC";
} else {
    // If division is not provided, return all offices for the campus, ordered alphabetically
    $sql = "SELECT office FROM tbl_office WHERE campus = '$campus' ORDER BY office ASC";
}

$result = $conn->query($sql);

$offices = [];

if ($result === false) {
    echo json_encode(["error" => "Query failed: " . $conn->error]);
} else {
    while ($row = $result->fetch_assoc()) {
        $offices[] = $row["office"];
    }
    echo json_encode(["offices" => $offices]);
}

$conn->close();
