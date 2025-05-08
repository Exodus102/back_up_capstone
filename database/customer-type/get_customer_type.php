<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$sql = "SELECT customer_type FROM tbl_customer_type";
$result = $conn->query($sql);

$customerTypes = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $customerTypes[] = $row;
    }
}

echo json_encode($customerTypes);

$conn->close();
