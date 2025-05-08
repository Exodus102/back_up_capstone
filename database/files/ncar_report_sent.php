<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $year = $_POST['year'] ?? '';
    $quarter = $_POST['quarter'] ?? '';
    $name = $_POST['name'] ?? '';
    $campus = $_POST['campus'] ?? '';
    $office = $_POST['office'] ?? '';

    // Fixed values
    $verify = 'Verify';
    $status = 'Unresolved';

    // File path generation
    $uploadDir = '../uploads/ncar/';
    $fileName = 'NCAR-Filled-' . preg_replace('/[^a-zA-Z0-9]/', '-', $office) . "-" . $campus . '.pdf';
    $filePath = $uploadDir . $fileName;

    // Check for existing report
    $checkSql = "SELECT id FROM tbl_sent_ncar_reports 
                 WHERE year = ? AND quarter = ? AND campus = ? AND file_name = ?";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->bind_param("ssss", $year, $quarter, $campus, $fileName);
    $checkStmt->execute();
    $checkStmt->store_result();

    if ($checkStmt->num_rows > 0) {
        echo json_encode(['success' => false, 'message' => 'Report has already been submitted.']);
        $checkStmt->close();
        $conn->close();
        exit;
    }
    $checkStmt->close();

    // Insert new report with office
    $sql = "INSERT INTO tbl_sent_ncar_reports 
            (year, quarter, name, campus, office, file_name, file_path, verify, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        echo json_encode(['success' => false, 'message' => 'Statement preparation failed']);
        exit;
    }

    $stmt->bind_param("sssssssss", $year, $quarter, $name, $campus, $office, $fileName, $filePath, $verify, $status);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Report submitted successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to submit report']);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request']);
}
