<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$survey_title = $_GET['survey_title'] ?? '';

if (empty($survey_title)) {
    echo json_encode(['error' => 'Survey title is required']);
    exit;
}

$response = [];

$sql = "
    SELECT q.id AS question_id, q.question, q.section, q.type, q.required, q.header, 
           q.transaction_type, q.question_rendering, 
           c.id AS choice_id, c.choice_text, 
           s.survey_title
    FROM tbl_question q
    LEFT JOIN tbl_choices c ON q.id = c.question_id
    INNER JOIN tbl_survey s ON q.survey_title = s.survey_title
    WHERE s.survey_title = ?  
    ORDER BY q.section, q.id, c.id
";


$stmt = $conn->prepare($sql);
$stmt->bind_param('s', $survey_title);
$stmt->execute();
$result = $stmt->get_result();

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $section = $row['section'];

        if (!isset($response[$section])) {
            $response[$section] = [];
        }

        $questionId = $row['question_id'];
        if (!isset($response[$section][$questionId])) {
            $response[$section][$questionId] = [
                'id' => $row['question_id'],
                'question' => $row['question'],
                'type' => $row['type'],
                'required' => $row['required'],
                'header' => $row['header'],
                'transaction_type' => $row['transaction_type'],
                'render' => $row['question_rendering'],
                'choices' => []
            ];
        }

        if ($row['choice_id']) {
            $response[$section][$questionId]['choices'][] = [
                'choice_id' => $row['choice_id'],
                'choice_text' => $row['choice_text'],
            ];
        }
    }

    $formattedResponse = [];
    foreach ($response as $section => $questions) {
        $formattedResponse[$section] = array_values($questions);
    }

    echo json_encode($formattedResponse);
} else {
    echo json_encode(['error' => 'Failed to fetch data: ' . $conn->error]);
}

$stmt->close();
$conn->close();
