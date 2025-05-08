<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if (isset($_GET['campus']) && isset($_GET['year']) && isset($_GET['quarter'])) {
    $campus = $_GET['campus'];
    $year = $_GET['year'];
    $quarter = $_GET['quarter'];

    // Adjust query to include year and quarter if applicable
    $stmt = $conn->prepare("SELECT office, Status, file_path, verify, id FROM tbl_sent_ncar_reports WHERE campus = ? AND year = ? AND quarter = ?");
    $stmt->bind_param("sss", $campus, $year, $quarter);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        $rows = [];

        while ($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }

        echo json_encode($rows);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Query execution failed."
        ]);
    }

    $stmt->close();
} else {
    echo json_encode([
        "success" => false,
        "message" => "Required parameters not provided."
    ]);
}

$conn->close();
