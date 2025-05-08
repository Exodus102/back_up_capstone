<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$campus = isset($_GET['campus']) ? $_GET['campus'] : 'Binangonan';
$office = isset($_GET['office']) ? $_GET['office'] : '';
$year = isset($_GET['year']) ? $_GET['year'] : date('Y');
$quarter = isset($_GET['quarter']) ? $_GET['quarter'] : getCurrentQuarter();

function getCurrentQuarter()
{
    $month = date('n');  // Get current month as an integer (1-12)

    if ($month >= 1 && $month <= 3) {
        return '1st Quarter';
    } elseif ($month >= 4 && $month <= 6) {
        return '2nd Quarter';
    } elseif ($month >= 7 && $month <= 9) {
        return '3rd Quarter';
    } else {
        return '4th Quarter';
    }
}

// Define months for each quarter
$quarterMonths = [
    '1st Quarter' => [1, 2, 3],
    '2nd Quarter' => [4, 5, 6],
    '3rd Quarter' => [7, 8, 9],
    '4th Quarter' => [10, 11, 12]
];

// Validate quarter
if (!array_key_exists($quarter, $quarterMonths)) {
    echo json_encode(['error' => 'Invalid quarter']);
    exit;
}

$results = [];

foreach ($quarterMonths[$quarter] as $monthNumber) {
    // Update the SQL query to use the new structure
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
        echo json_encode(['error' => "Prepare failed: " . $conn->error]);
        exit;
    }

    // Use bind_param with the selected quarter months
    $stmt->bind_param('iiss', $year, $monthNumber, $campus, $office);
    $stmt->execute();
    $result = $stmt->get_result();

    $response_id_count = 0;
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $response_id_count = $row['response_id_count'];
    }

    // Store the count of responses for the current month
    $results[$monthNumber] = $response_id_count;

    $stmt->close();
}

$conn->close();

// Output the result
echo json_encode([
    'office' => $office,
    'campus' => $campus,
    'quarter' => $quarter,
    'year' => $year,
    'data' => $results
]);
