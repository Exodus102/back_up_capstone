<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$sql = "SELECT campus FROM tbl_campus ORDER BY campus ASC";
$result = $conn->query($sql);

$campus_data = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $campus_data[] = $row;
    }
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($campus_data);
