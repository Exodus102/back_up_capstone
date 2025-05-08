<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

ini_set('display_errors', 1);
error_reporting(E_ALL);

$input = json_decode(file_get_contents('php://input'), true);

$campus = isset($input['campus']) ? trim($input['campus']) : '';
$office = isset($input['office']) ? trim($input['office']) : '';

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (empty($campus) || empty($office)) {
    echo json_encode(["error" => "Campus and office are required"]);
    exit();
}


$sql = "DELETE FROM tbl_office WHERE campus = ? AND office = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param('ss', $campus, $office);
$result = $stmt->execute();

if ($result) {
    echo json_encode(["success" => "Office deleted successfully"]);
} else {
    echo json_encode(["error" => "Failed to delete office"]);
}

$stmt->close();
$conn->close();
