<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$query = "SELECT office FROM tbl_office_list";
$result = mysqli_query($conn, $query);

$offices = [];
while ($row = mysqli_fetch_assoc($result)) {
    $offices[] = ['office' => $row['office']];
}

echo json_encode($offices);
