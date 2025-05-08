<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$campus = isset($_GET['campus']) ? $_GET['campus'] : 'Binangonan';

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


$sql = "SELECT office FROM tbl_office WHERE campus = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $campus);
$stmt->execute();
$result = $stmt->get_result();

$offices = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $offices[] = array('office' => $row['office']);
    }
} else {
    echo "0 results";
}

header('Content-Type: application/json');
echo json_encode($offices);

$stmt->close();
$conn->close();
