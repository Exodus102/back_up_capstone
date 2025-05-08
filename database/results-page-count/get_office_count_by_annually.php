<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$campus = isset($_GET['campus']) ? $_GET['campus'] : 'Binangonan';
$office = isset($_GET['office']) ? $_GET['office'] : '';
$year = isset($_GET['year']) ? $_GET['year'] : date('Y');

$response = ["data" => []];

if ($campus && $office && $year) {
    // Loop through all months of the year (1 to 12)
    for ($month = 1; $month <= 12; $month++) {

        $stmt = $conn->prepare("
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
        ");

        // Bind parameters: year, month, office, campus
        $stmt->bind_param("iiss", $year, $month, $office, $campus);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        // Store the count for each month (using the month as a string key)
        $response["data"][(string) $month] = (int) $row["response_id_count"];
    }
} else {
    $response["error"] = "Missing parameters.";
}

echo json_encode($response);
