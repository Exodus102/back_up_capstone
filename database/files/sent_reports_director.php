<?php
require('../db_connection.php');

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

$year = $_POST['year'];
$quarter = $_POST['quarter'];
$name = $_POST['name'];
$campus = $_POST['campus'];
$endorse_by = isset($_POST['endorse_by']) ? $_POST['endorse_by'] : null;

// Check if a report has already been submitted for the same year and quarter
$check_sql = "SELECT * FROM tbl_sent_reports WHERE year = ? AND quarter = ? AND campus = ?";
$check_stmt = $conn->prepare($check_sql);
$check_stmt->bind_param("sss", $year, $quarter, $campus);
$check_stmt->execute();
$check_result = $check_stmt->get_result();

if ($check_result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "You already submitted the report for this quarter."]);
} else {

        $filename = "{$campus}_report_{$year}_{$quarter}.pdf";
        $file_path = "../uploads/" . $filename;
        $status = 'Pending';

        $sql = "INSERT INTO tbl_sent_reports (year, quarter, name, campus, filename, file_path, endorse_by, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssssss", $year, $quarter, $name, $campus, $filename, $file_path, $endorse_by, $status);
        $stmt->execute();
        $stmt->close();

        echo json_encode(["status" => "success", "message" => "Report submitted successfully."]);
}

$check_stmt->close();
$conn->close();
