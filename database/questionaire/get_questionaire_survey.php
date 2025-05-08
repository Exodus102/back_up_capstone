<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$response = [];

$sql = "
    SELECT q.id AS question_id, q.question, q.type, q.required, 
           c.id AS choice_id, c.choice_text
    FROM tbl_question q
    LEFT JOIN tbl_choices c ON q.id = c.question_id
    WHERE q.status = 1 
    ORDER BY q.id, c.id
";

$result = $conn->query($sql);

if ($result) {
    $questions = [];

    while ($row = $result->fetch_assoc()) {
        $questionId = $row['question_id'];

        if (!isset($questions[$questionId])) {
            $questions[$questionId] = [
                'id' => $questionId,
                'question' => $row['question'],
                'type' => $row['type'],
                'required' => $row['required'],
                'choices' => []
            ];
        }

        if ($row['choice_id']) {
            $questions[$questionId]['choices'][] = [
                'choice_id' => $row['choice_id'],
                'choice_text' => $row['choice_text'],
            ];
        }
    }

    echo json_encode(array_values($questions));
} else {
    echo json_encode(['error' => 'Failed to fetch data: ' . $conn->error]);
}

$conn->close();
