<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$campus = $_POST['campus'];
$division = $_POST['division'];
$unit = $_POST['unit'];

if (empty($campus) || empty($division) || empty($unit)) {
    echo json_encode(['success' => false, 'message' => 'Please fill in all fields']);
    exit();
}

$check_sql = "SELECT * FROM tbl_office WHERE office = '$unit' AND campus = '$campus'";
$result = $conn->query($check_sql);

if ($result->num_rows > 0) {
    echo json_encode(['success' => false, 'message' => 'Office already exists']);
    exit();
}

$sql = "INSERT INTO tbl_office (campus, division, office) VALUES ('$campus', '$division', '$unit')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['success' => true, 'message' => 'Unit added successfully']);
} else {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $conn->error]);
}

$conn->close();
