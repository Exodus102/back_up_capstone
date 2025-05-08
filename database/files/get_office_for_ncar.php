<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

// Get campus and year from the GET request
$campus = isset($_GET['campus']) ? $conn->real_escape_string($_GET['campus']) : '';
$year = isset($_GET['year']) ? $conn->real_escape_string($_GET['year']) : '';
$quarter = isset($_GET['quarter']) ? $conn->real_escape_string($_GET['quarter']) : '';

$quarterMonths = [
    "1st Quarter" => [1, 2, 3],
    "2nd Quarter" => [4, 5, 6],
    "3rd Quarter" => [7, 8, 9],
    "4th Quarter" => [10, 11, 12],
];

$months = isset($quarterMonths[$quarter]) ? $quarterMonths[$quarter] : [];

$monthCondition = '';
if (!empty($months)) {
    $monthCondition = "AND MONTH(r.timestamp) IN (" . implode(",", $months) . ")";
}

// Fetch unique offices based on campus and year filter
$sql = "
    SELECT DISTINCT o.office
    FROM tbl_responses r
    JOIN tbl_office o ON o.office = r.response
    WHERE r.analysis = 'negative'
    AND o.campus LIKE '%$campus%'
    AND YEAR(r.timestamp) = '$year'
    $monthCondition";

$result = $conn->query($sql);

$negative_offices = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $office = $row['office'];

        // Prepare data for insertion into tbl_ncar_reports
        $status = "Unresolved";
        $verify = "Verify";

        // Check if the office already exists in the reports table
        $checkStmt = $conn->prepare("SELECT id FROM tbl_ncar_reports WHERE office = ?");
        $checkStmt->bind_param("s", $office);
        $checkStmt->execute();
        $checkResult = $checkStmt->get_result();

        if ($checkResult->num_rows == 0) {
            // Insert the office into tbl_ncar_reports if not already present
            $insertStmt = $conn->prepare("INSERT INTO tbl_ncar_reports (campus, status, verify, office) VALUES (?, ?, ?, ?)");
            $insertStmt->bind_param("ssss", $campus, $status, $verify, $office);
            $insertStmt->execute();
        }

        // Add the office to the response array
        $negative_offices[] = [
            'office' => $office,
            'Actions' => 'View',
            'Status' => 'Unresolved'
        ];
    }
}

$conn->close();

echo json_encode($negative_offices);
