<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['questions'])) {
    echo json_encode(["error" => "No questions provided"]);
    exit;
}

$deletedQuestions = [];

foreach ($data['questions'] as $question) {
    $section = $question['section'];
    $question_text = $question['question'];

    $delete_query = "DELETE FROM tbl_question WHERE section = ? AND question = ?";
    $delete_stmt = $conn->prepare($delete_query);
    $delete_stmt->bind_param("ss", $section, $question_text);

    if ($delete_stmt->execute()) {
        $deletedQuestions[] = $question_text;
    }
}

echo json_encode([
    "message" => "Questions deleted successfully",
    "deleted_questions" => $deletedQuestions
]);

$conn->close();
