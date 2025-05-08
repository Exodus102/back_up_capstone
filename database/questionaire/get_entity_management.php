<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = array();

$tables = [
    'tbl_division' => 'division',
    'tbl_campus' => 'campus',
    'tbl_office_list' => 'office'
];

foreach ($tables as $table => $column) {
    $sql = "SELECT $column AS name FROM $table";
    $result = $conn->query($sql);
    $data[$table] = array();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[$table][] = $row['name'];
        }
    }
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($data);
