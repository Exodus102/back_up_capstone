<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$selectedDivision = isset($_GET['division']) ? $_GET['division'] : null;

$sql = "SELECT office, status FROM tbl_office_reports";
if ($selectedDivision && $selectedDivision !== "Show All") {
    $sql .= " WHERE division = ?";
}

$stmt = $conn->prepare($sql);
if ($selectedDivision && $selectedDivision !== "Show All") {
    $stmt->bind_param("s", $selectedDivision);
}
$stmt->execute();
$result = $stmt->get_result();
$reports = [];
while ($row = $result->fetch_assoc()) {
    $reports[] = $row;
}

echo json_encode($reports);
$stmt->close();
$conn->close();
