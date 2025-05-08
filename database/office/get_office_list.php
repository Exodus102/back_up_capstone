<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$division = $_POST['division'];

if ($division == 'Show All') {
    $sql = "SELECT office FROM tbl_office_list";
} else {
    $sql = "SELECT office FROM tbl_office_list WHERE division = '$division'";
}

$result = $conn->query($sql);

$offices = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $offices[] = $row['office'];
    }
}

echo json_encode($offices);

$conn->close();
