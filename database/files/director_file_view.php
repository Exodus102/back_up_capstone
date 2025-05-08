<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

$year = isset($_GET['year']) ? $_GET['year'] : date("Y");
$quarter = isset($_GET['quarter']) ? $_GET['quarter'] : "1st Quarter CSS Report";
$campus = isset($_GET['campus']) ? $_GET['campus'] : '';

// Check if record exists in tbl_sent_reports
$checkQuery = "SELECT * FROM tbl_sent_reports WHERE year = ? AND quarter = ? AND campus = ?";
$stmt = $conn->prepare($checkQuery);
$stmt->bind_param("sss", $year, $quarter, $campus);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    // No record found, don't serve PDF
    echo json_encode(["status" => "error", "message" => "Report not submitted yet for $quarter $year."]);
    exit;
}

// Record found, proceed to serve the PDF
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
