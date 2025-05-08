<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';


$transactionType = isset($_GET['transaction_type']) ? intval($_GET['transaction_type']) : 0;


$sql = "SELECT id, question, section, type, required, status, transaction_type 
        FROM tbl_question 
        WHERE status = 1 
        AND (transaction_type = 0 OR transaction_type = ?) 
        ORDER BY section, id";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $transactionType);
$stmt->execute();
$result = $stmt->get_result();

$sections = [];

while ($row = $result->fetch_assoc()) {
    $sectionName = $row['section'];
    $questionId = $row['id'];

    // Fetch choices for this question if any
    $choices_sql = "SELECT choice_text FROM tbl_choices WHERE question_id = ?";
    $choices_stmt = $conn->prepare($choices_sql);
    $choices_stmt->bind_param("i", $questionId);
    $choices_stmt->execute();
    $choices_result = $choices_stmt->get_result();

    $choices = [];
    while ($choice_row = $choices_result->fetch_assoc()) {
        $choices[] = $choice_row['choice_text'];
    }

    $questionData = [
        "id" => $questionId,
        "question" => $row['question'],
        "type" => $row['type'],
        "required" => (bool) $row['required'],
        "status" => $row['status'],
        "transaction_type" => $row['transaction_type'],
    ];

    if (!empty($choices)) {
        $questionData['choices'] = $choices;
    }

    if (!isset($sections[$sectionName])) {
        $sections[$sectionName] = [];
    }

    $sections[$sectionName][] = $questionData;
}

echo json_encode($sections, JSON_PRETTY_PRINT);

$conn->close();
