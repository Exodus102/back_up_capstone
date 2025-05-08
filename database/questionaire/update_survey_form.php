<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $survey_title = $_POST['survey_title'];

    if (empty($survey_title)) {
        echo json_encode(['status' => 'error', 'message' => 'Survey title is missing']);
        exit;
    }

    $reset_query = "UPDATE tbl_survey SET status = 0 WHERE status = 1";
    $reset_stmt = $conn->prepare($reset_query);
    $reset_result = $reset_stmt->execute();

    if ($reset_result) {

        // 3. Update the survey status to 1 for the given survey_title
        $update_query = "UPDATE tbl_survey SET status = 1 WHERE survey_title = ?";
        $update_stmt = $conn->prepare($update_query);
        $update_stmt->bind_param('s', $survey_title);
        $update_result = $update_stmt->execute();

        if ($update_result) {
            // Reset question statuses for surveys that are no longer active
            $reset_questions_query = "UPDATE tbl_question SET status = 0 WHERE survey_title NOT IN (SELECT survey_title FROM tbl_survey WHERE status = 1)";
            $reset_questions_stmt = $conn->prepare($reset_questions_query);
            $reset_questions_stmt->execute();

            // 4. Update the question statuses to 1 to match the survey status
            $update_questions_query = "UPDATE tbl_question SET status = 1 WHERE survey_title = ?";
            $update_questions_stmt = $conn->prepare($update_questions_query);
            $update_questions_stmt->bind_param('s', $survey_title);

            if ($update_questions_stmt->execute()) {

                // 5. Fetch all questions for the given survey_title
                $select_query = "SELECT * FROM tbl_question WHERE survey_title = ?";
                $select_stmt = $conn->prepare($select_query);
                $select_stmt->bind_param('s', $survey_title);
                $select_stmt->execute();
                $result = $select_stmt->get_result();

                $questions = [];
                while ($row = $result->fetch_assoc()) {
                    $questions[] = $row;
                }

                echo json_encode([
                    'status' => 'success',
                    'message' => 'Survey updated successfully.',
                    'questions' => $questions
                ]);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Failed to update question statuses: ' . $update_questions_stmt->error]);
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to update survey status']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to reset previous surveys']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request']);
}
