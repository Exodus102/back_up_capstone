<?php

require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

$campus = isset($_GET['campus']) ? $_GET['campus'] : null;
$office = isset($_GET['office']) ? $_GET['office'] : null;

$fileName = 'NCAR-Filled-' . preg_replace('/[^a-zA-Z0-9]/', '-', $office) . "-" . $campus  . '.pdf';
$filePath = "../uploads/ncar/" . $fileName;

if (file_exists($filePath)) {
    header("Content-Type: application/pdf");
    header("Content-Disposition: inline; filename=\"$fileName\"");
    readfile($filePath);
    exit;
} else {

    echo json_encode(["status" => "error", "message" => "File not found: $fileName"]);
}
