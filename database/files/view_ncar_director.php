<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

// Get the file path from the GET request
$filePath = isset($_GET['file_path']) ? $_GET['file_path'] : null;

if ($filePath && file_exists($filePath)) {
    // Extract the file name for the header
    $fileName = basename($filePath);

    header("Content-Type: application/pdf");
    header("Content-Disposition: inline; filename=\"$fileName\"");
    readfile($filePath);
    exit;
} else {
    echo json_encode(["status" => "error", "message" => "File not found: $filePath"]);
}
