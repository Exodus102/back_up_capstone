<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["error" => "Invalid data"]);
    exit;
}

$response_data = $data["responses"];
$comment = $data["comment"];
$analysis = $data["analysis"];

// Get and remove transaction_type from responses
$transaction_type = $response_data['transaction_type'] ?? null;
unset($response_data['transaction_type']);

$conn->begin_transaction();

try {
    $result = $conn->query("SELECT MAX(response_id) AS max_id FROM tbl_responses");
    $row = $result->fetch_assoc();
    $next_response_id = ($row['max_id'] ?? 0) + 1;

    foreach ($response_data as $question_id => $response) {
        $question_result = $conn->query("SELECT header, question_rendering FROM tbl_question WHERE id = $question_id");
        $question_row = $question_result->fetch_assoc();

        $header = $question_row['header'];
        $question_rendering = $question_row['question_rendering'];
        $uploaded = 0;
        $stmt = $conn->prepare("INSERT INTO tbl_responses (response_id, question_id, response, comment, analysis, header, transaction_type, question_rendering, uploaded) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("iissssssi", $next_response_id, $question_id, $response, $comment, $analysis, $header, $transaction_type, $question_rendering, $uploaded);
        $stmt->execute();
    }


    $conn->commit();
    echo json_encode(["success" => "Data inserted successfully", "response_id" => $next_response_id]);
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["error" => $e->getMessage()]);
}

$conn->close();
