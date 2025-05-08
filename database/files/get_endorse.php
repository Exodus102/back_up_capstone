<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

$year = $_GET['year'];
$campus = $_GET['campus'];
$quarter = $_GET['quarter'];

$query = "SELECT endorse_by FROM tbl_sent_reports WHERE year = ? AND campus = ? AND quarter = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("sss", $year, $campus, $quarter);
$stmt->execute();
$result = $stmt->get_result();

$data = array();
while ($row = $result->fetch_assoc()) {
    $data[] = $row; // collect all rows
}
echo json_encode($data);
