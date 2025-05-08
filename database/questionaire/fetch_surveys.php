<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$query = "SELECT survey_title, status FROM tbl_survey";
$result = mysqli_query($conn, $query);

$surveys = [];
if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $surveys[] = $row;
    }
}

echo json_encode($surveys);
