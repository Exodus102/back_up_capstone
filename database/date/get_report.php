<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$selectedYear = isset($_GET['year']) ? $_GET['year'] : date('Y');
$campus = isset($_GET['campus']) ? $_GET['campus'] : ''; // Retrieve the campus parameter

if (empty($campus)) {
    echo json_encode(['error' => 'Campus is required']);
    exit;
}

$deleteSql = "DELETE FROM tbl_quarter_report WHERE year = '0000'";
$conn->query($deleteSql);

$sql = "SELECT id, quarter_report, status, year, quarter_report_id, campus FROM tbl_quarter_report WHERE year = '$selectedYear' AND campus = '$campus'";
$result = $conn->query($sql);

$reports = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $reports[] = $row;
    }
} else {
    // If no reports exist for the selected year and campus, insert new ones
    for ($i = 1; $i <= 4; $i++) {
        $suffix = ($i == 1) ? 'st' : (($i == 2) ? 'nd' : (($i == 3) ? 'rd' : 'th'));

        $quarter_report = "$i" . $suffix . " Quarter CSS Report";
        $status = 'Pending';

        $insertSql = "INSERT INTO tbl_quarter_report (quarter_report, status, year, campus) 
                      VALUES ('$quarter_report', '$status', '$selectedYear', '$campus')";
        if ($conn->query($insertSql) === TRUE) {
            $quarterly_report_id = $conn->insert_id;
            $updateSql = "UPDATE tbl_quarter_report 
                          SET quarter_report_id = '$quarterly_report_id' 
                          WHERE id = '$quarterly_report_id'";
            $conn->query($updateSql);
            $reports[] = [
                'quarterly_report_id' => $quarterly_report_id,
                'quarter_report' => $quarter_report,
                'status' => $status,
                'year' => $selectedYear,
                'campus' => $campus
            ];
        }
    }
}

echo json_encode($reports);

$conn->close();
