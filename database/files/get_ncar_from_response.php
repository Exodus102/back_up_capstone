<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query
$sql = "
    SELECT r.response_id, r.response AS office, r.comment, r.analysis
    FROM tbl_responses r
    WHERE LOWER(r.response) = 'campus directors'
    AND r.response_id IN (
        SELECT response_id
        FROM tbl_responses
        WHERE LOWER(response) = 'binangonan'
    )
    AND YEAR(r.timestamp) = 2025;
";

// Execute the query
$result = $conn->query($sql);

// Check if there are results
if ($result->num_rows > 0) {
    // Output data of each row
    while ($row = $result->fetch_assoc()) {
        echo "Response ID: " . $row["response_id"] . " - Office: " . $row["office"] . " - Comment: " . $row["comment"] . " - Analysis: " . $row["analysis"] . "<br>";
    }
} else {
    echo "0 results found";
}

// Close the connection
$conn->close();
