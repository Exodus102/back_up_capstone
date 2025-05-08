<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';


$column_query = "SHOW COLUMNS FROM tbl_response";
$column_result = $conn->query($column_query);
$columns = [];

if ($column_result) {
    while ($row = $column_result->fetch_assoc()) {
        $columns[] = $row['Field'];
    }
} else {
    die(json_encode(["error" => "Failed to get columns: " . $conn->error]));
}


$data_query = "SELECT * FROM tbl_response";
$data_result = $conn->query($data_query);
$data = [];

if ($data_result) {
    while ($row = $data_result->fetch_assoc()) {
        $data[] = $row;
    }
} else {
    die(json_encode(["error" => "Failed to get data: " . $conn->error]));
}


$response = [
    "columns" => $columns,
    "data" => $data,
];

echo json_encode($response, JSON_PRETTY_PRINT);
$conn->close();
