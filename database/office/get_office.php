<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$sql = "SELECT office FROM tbl_office";
$result = $conn->query($sql);

$offices = [];

if ($result === false) {
    echo json_encode(["error" => "Query failed: " . $conn->error]);
} else {
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $offices[] = $row["office"];
        }
    }
    echo json_encode(["offices" => $offices]);
}

$conn->close();
