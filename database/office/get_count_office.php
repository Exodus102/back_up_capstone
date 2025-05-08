<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

// Get the campus, office, year, and month from the query parameters
$campus = isset($_GET['campus']) ? $_GET['campus'] : 'Binangonan';
$office = isset($_GET['office']) ? $_GET['office'] : '';
$year = isset($_GET['year']) ? $_GET['year'] : date('Y');
$monthName = isset($_GET['month']) ? $_GET['month'] : date('F'); // F gives full month name (e.g., April)

// Convert month name to month number
$monthNumber = date('m', strtotime($monthName));

if ($conn->connect_error) {
    die(json_encode(['error' => "Connection failed: " . $conn->connect_error]));
}

// SQL query
$sql = "
    SELECT COUNT(*) AS response_id_count
    FROM (
        SELECT response_id
        FROM tbl_responses
        WHERE YEAR(timestamp) = ? AND MONTH(timestamp) = ?
        GROUP BY response_id
        HAVING 
            SUM(CASE WHEN response = ? THEN 1 ELSE 0 END) > 0
            AND
            SUM(CASE WHEN response = ? THEN 1 ELSE 0 END) > 0
    ) AS filtered;
";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    die(json_encode(['error' => "Prepare failed: " . $conn->error]));
}

$stmt->bind_param('iiss', $year, $monthNumber, $campus, $office);

if (!$stmt->execute()) {
    die(json_encode(['error' => "Execute failed: " . $stmt->error]));
}

$result = $stmt->get_result();

$response_id_count = 0;

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $response_id_count = $row['response_id_count'];
}

echo json_encode(['response_id_count' => $response_id_count]);

$stmt->close();
$conn->close();
