<?php
// header("Content-Type: application/json");
// header("Access-Control-Allow-Origin: *");
// header("Access-Control-Allow-Methods: POST");
// header("Access-Control-Allow-Headers: Content-Type");

// require '../db_connection.php';

// $campus = isset($_GET['campus']) ? $_GET['campus'] : 'Binangonan';

// if ($conn->connect_error) {
//     die("Connection failed: " . $conn->connect_error);
// }

// $sql = "SELECT office FROM tbl_office WHERE campus = ?";
// $stmt = $conn->prepare($sql);
// $stmt->bind_param('s', $campus);
// $stmt->execute();
// $result = $stmt->get_result();

// $offices = array();

// if ($result->num_rows > 0) {
//     while ($row = $result->fetch_assoc()) {
//         $offices[] = array('office' => $row['office']);
//     }
// } else {
//     echo "0 results";
// }

// header('Content-Type: application/json');
// echo json_encode($offices);

// $stmt->close();
// $conn->close();

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$campus = isset($_GET['campus']) ? $_GET['campus'] : 'Binangonan';
$division = isset($_GET['division']) ? $_GET['division'] : null; // Default to null if not set

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// If division is null or empty, fetch offices based only on campus
if ($division === null) {
    $sql = "SELECT office FROM tbl_office WHERE campus = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('s', $campus);
} else {
    $sql = "SELECT office FROM tbl_office WHERE campus = ? AND division = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ss', $campus, $division);
}

$stmt->execute();
$result = $stmt->get_result();

$offices = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $offices[] = ['office' => $row['office']];
    }
}

echo json_encode($offices);

$stmt->close();
$conn->close();
