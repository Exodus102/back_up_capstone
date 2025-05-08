<?php
require('../db_connection.php');
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Connection failed']));
}

$office = $_POST['office'];
$year = $_POST['year'];
$campus = $_POST['campus'];
$quarter = $_POST['quarter'];

$sql = "UPDATE tbl_sent_ncar_reports 
        SET verify='Verified' 
        WHERE office=? AND year=? AND campus=? AND quarter=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssss", $office, $year, $campus, $quarter);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Update failed']);
}

$stmt->close();
$conn->close();
