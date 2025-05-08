<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Get campus_name from query parameter if present
$campusName = isset($_GET['campus_name']) ? trim($_GET['campus_name']) : null;

$sql = "
    SELECT 
        response_id,
        GROUP_CONCAT(response SEPARATOR ', ') AS responses,
        comment,
        analysis
    FROM tbl_responses
    WHERE uploaded = 0
    GROUP BY response_id, comment, analysis
";

$result = $conn->query($sql);

$responseData = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $row['responseList'] = array_map('trim', explode(',', $row['responses']));

        if ($campusName) {
            if (!in_array($campusName, $row['responseList'])) {
                continue; // Skip this row if it doesn't contain the campus name
            }
        }

        $responseData[] = $row;
    }
}

echo json_encode($responseData, JSON_UNESCAPED_UNICODE);

$conn->close();
