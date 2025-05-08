<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST");
header("Access-Control-Allow-Headers: Content-Type");

$year = $_GET['year'] ?? '';
$campus = $_GET['campus'] ?? '';
$quarter = $_GET['quarter'] ?? '';

if (empty($year) || empty($campus) || empty($quarter)) {
    echo json_encode(['status' => 'error', 'message' => 'Missing parameters']);
    exit;
}

// Check if already endorsed
$checkQuery = $conn->prepare("SELECT endorse_by, status FROM tbl_sent_reports WHERE year = ? AND campus = ? AND quarter = ?");
$checkQuery->bind_param("sss", $year, $campus, $quarter);
$checkQuery->execute();
$checkResult = $checkQuery->get_result();

if ($checkResult->num_rows > 0) {
    $row = $checkResult->fetch_assoc();
    if ($row['endorse_by'] === 'Endorsed' && $row['status'] === 'Approved') {
        echo json_encode(['status' => 'already_endorsed', 'message' => 'This report has already been endorsed.']);
        exit;
    }
}

// Update tbl_sent_reports
$updateSentReports = $conn->prepare("UPDATE tbl_sent_reports SET endorse_by = 'Endorsed', status = 'Approved' WHERE year = ? AND campus = ? AND quarter = ?");
$updateSentReports->bind_param("sss", $year, $campus, $quarter);
$sentSuccess = $updateSentReports->execute();

// Update tbl_quarter_report
$updateQuarterReport = $conn->prepare("UPDATE tbl_quarter_report SET status = 'Approved' WHERE year = ? AND campus = ? AND quarter_report = ?");
$updateQuarterReport->bind_param("sss", $year, $campus, $quarter);
$quarterSuccess = $updateQuarterReport->execute();

if ($sentSuccess && $quarterSuccess) {
    echo json_encode(['status' => 'success', 'message' => 'Data updated successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update records']);
}
