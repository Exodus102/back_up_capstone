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

$errors = [];

foreach ($data['questions'] as $question) {
    $section = $question['section'];
    $old_question_text = $question['old_question'];
    $question_text = $question['question'];
    $type = $question['type'];
    $status = 1;
    $survey_title = $question['survey_title'];
    $header = isset($question['header']) ? (int)$question['header'] : 0;
    $required = isset($question['required']) ? (int)$question['required'] : 1;
    $new_choices = isset($question['choices']) ? $question['choices'] : [];

    // Log received question
    error_log("Processing Question: " . json_encode($question), 3, 'C:/xampp/htdocs/database/questionaire/error_log.txt');

    try {
        // Check if the question already exists with the same status
        $check_query = "SELECT id FROM tbl_question WHERE section = ? AND question = ? AND status = 1";
        $check_stmt = $conn->prepare($check_query);
        $check_stmt->bind_param("ss", $section, $question_text);
        $check_stmt->execute();
        $result = $check_stmt->get_result();
        $existing_question = $result->fetch_assoc();
        $check_stmt->close();

        if ($existing_question) {
            continue;
        }

        // Check if the old question exists to update it
        $check_old_query = "SELECT id FROM tbl_question WHERE section = ? AND question = ? AND status = 1";
        $check_old_stmt = $conn->prepare($check_old_query);
        $check_old_stmt->bind_param("ss", $section, $old_question_text);
        $check_old_stmt->execute();
        $result_old = $check_old_stmt->get_result();
        $existing_old_question = $result_old->fetch_assoc();
        $check_old_stmt->close();

        if ($existing_old_question) {
            $question_id = $existing_old_question['id'];
            $update_query = "UPDATE tbl_question SET question = ?, type = ?, required = ? WHERE id = ?";
            $update_stmt = $conn->prepare($update_query);
            $update_stmt->bind_param("ssii", $question_text, $type, $required, $question_id);
            $update_stmt->execute();
            $update_stmt->close();
            error_log("Updating question ID: $question_id with required: $required", 3, 'C:/xampp/htdocs/database/questionaire/error_log.txt');
        } else {
            $insert_query = "INSERT INTO tbl_question (section, question, type, status, required) VALUES (?, ?, ?, ?, ?)";
            $insert_stmt = $conn->prepare($insert_query);
            $insert_stmt->bind_param("sssii", $section, $question_text, $type, $status, $required);
            if (!$insert_stmt->execute()) {
                throw new Exception("Failed to insert question: " . $insert_stmt->error);
            }
            $question_id = $insert_stmt->insert_id;
            $insert_stmt->close();
        }

        // Handling choices
        $existing_choices_query = "SELECT choice_text FROM tbl_choices WHERE question_id = ?";
        $existing_choices_stmt = $conn->prepare($existing_choices_query);
        $existing_choices_stmt->bind_param("i", $question_id);
        $existing_choices_stmt->execute();
        $existing_choices_result = $existing_choices_stmt->get_result();
        $existing_choices = [];

        while ($row = $existing_choices_result->fetch_assoc()) {
            $existing_choices[] = $row['choice_text'];
        }
        $existing_choices_stmt->close();

        $new_choices_text = array_map(fn($c) => $c['choice_text'], $new_choices);
        $choices_to_add = array_diff($new_choices_text, $existing_choices);
        $choices_to_remove = array_diff($existing_choices, $new_choices_text);

        if (!empty($choices_to_add)) {
            $insert_choice_query = "INSERT INTO tbl_choices (question_id, choice_text) VALUES (?, ?)";
            $insert_choice_stmt = $conn->prepare($insert_choice_query);

            foreach ($choices_to_add as $choice_text) {
                $insert_choice_stmt->bind_param("is", $question_id, $choice_text);
                if (!$insert_choice_stmt->execute()) {
                    throw new Exception("Failed to insert choice: " . $insert_choice_stmt->error);
                }
            }
            $insert_choice_stmt->close();
        }

        if (!empty($choices_to_remove)) {
            $delete_choice_query = "DELETE FROM tbl_choices WHERE question_id = ? AND choice_text = ?";
            $delete_choice_stmt = $conn->prepare($delete_choice_query);

            foreach ($choices_to_remove as $choice_text) {
                $delete_choice_stmt->bind_param("is", $question_id, $choice_text);
                if (!$delete_choice_stmt->execute()) {
                    throw new Exception("Failed to delete choice: " . $delete_choice_stmt->error);
                }
            }
            $delete_choice_stmt->close();
        }
    } catch (Exception $e) {
        error_log("Error Processing Question: " . json_encode($question) . " - " . $e->getMessage(), 3, 'C:/xampp/htdocs/database/questionaire/error_log.txt');
        $errors[] = [
            "question" => $question_text,
            "section" => $section,
            "error" => $e->getMessage()
        ];
    }
}

if (isset($data['deletedQuestions'])) {
    foreach ($data['deletedQuestions'] as $deletedQuestion) {
        try {
            $section = $deletedQuestion['section'];
            $question_text = $deletedQuestion['question'];

            $delete_question_query = "DELETE FROM tbl_question WHERE section = ? AND question = ?";
            $delete_question_stmt = $conn->prepare($delete_question_query);
            $delete_question_stmt->bind_param("ss", $section, $question_text);
            if (!$delete_question_stmt->execute()) {
                throw new Exception("Failed to delete question: " . $delete_question_stmt->error);
            }
            $delete_question_stmt->close();
        } catch (Exception $e) {
            error_log("Error Deleting Question: " . json_encode($deletedQuestion) . " - " . $e->getMessage(), 3, 'C:/xampp/htdocs/database/questionaire/error_log.txt');
            $errors[] = [
                "question" => $deletedQuestion['question'],
                "section" => $deletedQuestion['section'],
                "error" => $e->getMessage()
            ];
        }
    }
}

$response = ["success" => "Survey processed successfully"];

if (!empty($errors)) {
    $response["errors"] = $errors;
}

echo json_encode($response);
$conn->close();
