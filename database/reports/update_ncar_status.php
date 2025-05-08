<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$office = $_POST['office'];
$year = $_POST['year'];
$campus = $_POST['campus'];
$quarter = $_POST['quarter'];

$sql = "UPDATE tbl_sent_ncar_reports SET Status='Resolved' 
        WHERE office=? AND year=? AND campus=? AND quarter=?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssss", $office, $year, $campus, $quarter);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => $stmt->error]);
}
