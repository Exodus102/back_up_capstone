<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

$year = isset($_GET['year']) ? $_GET['year'] : date("Y");
$quarter = isset($_GET['quarter']) ? $_GET['quarter'] : "1st Quarter CSS Report";
$campus = isset($_GET['campus']) ? $_GET['campus'] : '';

$fileName = "{$campus}_report_{$year}_{$quarter}.pdf";
$filePath = "../uploads/" . $fileName;

if (file_exists($filePath)) {
    header("Content-Type: application/pdf");
    header("Content-Disposition: inline; filename=\"$fileName\"");
    readfile($filePath);
    exit;
} else {

    echo json_encode(["status" => "error", "message" => "File not found: $fileName"]);
}
