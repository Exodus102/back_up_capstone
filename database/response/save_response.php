<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents('php://input'), true);

foreach ($data as $question_id => $response) {
    if ($question_id === 'feedback') {
        $query = "INSERT INTO tbl_responses (question_id, response_text) VALUES (NULL, ?)";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("s", $response);
    } else {
        $choice_id = null;
        if (!empty($response)) {
            $choice_query = "SELECT id FROM tbl_choices WHERE question_id = ? AND choice_text = ?";
            $choice_stmt = $conn->prepare($choice_query);
            $choice_stmt->bind_param("is", $question_id, $response);
            $choice_stmt->execute();
            $result = $choice_stmt->get_result();
            if ($row = $result->fetch_assoc()) {
                $choice_id = $row['id'];
            }
        }
        $query = "INSERT INTO tbl_responses (question_id, choice_id, response_text) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("iis", $question_id, $choice_id, $response);
    }
    $stmt->execute();
}

echo json_encode(["success" => true]);
$conn->close();
