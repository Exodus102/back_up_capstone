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

$questions = $data['questions'];
$deletedQuestions = $data['deletedQuestions'] ?? [];

foreach ($questions as $question) {
    $section = $question['section'];
    $question_text = $question['question'];
    $type = $question['type'];
    $required = isset($question['required']) ? (int)$question['required'] : 0;
    $survey_title = trim($question['survey_title']);
    $header = isset($question['header']) ? (int)$question['header'] : 0;
    $transaction_type_str = $question['transaction_type'];
    $render = $question['render'] ?? '';

    if ($transaction_type_str == 'Default') {
        $transaction_type_str = 0;
    } elseif ($transaction_type_str == 'Face-to-Face') {
        $transaction_type_str = 1;
    } elseif ($transaction_type_str == 'Online') {
        $transaction_type_str = 2;
    }

    $survey_status = 1;
    $survey_stmt = $conn->prepare("SELECT status FROM tbl_survey WHERE survey_title = ?");
    $survey_stmt->bind_param("s", $survey_title);
    $survey_stmt->execute();
    $survey_result = $survey_stmt->get_result();
    if ($row = $survey_result->fetch_assoc()) {
        $survey_status = $row['status'];
    }
    $survey_stmt->close();

    if (isset($question['old_question']) && !empty($question['old_question'])) {
        $old_question = trim($question['old_question']); // Trim whitespace
        $old_question = strtolower($old_question); // Normalize case
        $old_question_db = '';

        $check_stmt = $conn->prepare("SELECT question FROM tbl_question WHERE survey_title = ?");
        $check_stmt->bind_param("s", $survey_title);
        $check_stmt->execute();
        $check_stmt->store_result();
        $check_stmt->bind_result($old_question_db);

        $found = false;
        while ($check_stmt->fetch()) {
            if (strtolower(trim($old_question_db)) == $old_question) {
                $found = true;
                break;
            }
        }

        if ($found) {
            $update_stmt = $conn->prepare("UPDATE tbl_question SET section = ?, question = ?, type = ?, status = ?, required = ?, header = ?, transaction_type = ?, question_rendering = ? WHERE question = ? AND survey_title = ?");
            $update_stmt->bind_param("sssiiiisss", $section, $question_text, $type, $survey_status, $required, $header, $transaction_type_str, $render, $old_question_db, $survey_title);
            if (!$update_stmt->execute()) {
                echo json_encode(["error" => "Update failed: " . $update_stmt->error]);
                exit;
            }
            $update_stmt->close();
        } else {
            $insert_stmt = $conn->prepare("INSERT INTO tbl_question (section, question, type, status, required, survey_title, header, transaction_type, question_rendering) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $insert_stmt->bind_param("sssisssis", $section, $question_text, $type, $survey_status, $required, $survey_title, $header, $transaction_type_str, $render);
            if (!$insert_stmt->execute()) {
                echo json_encode(["error" => "Insert failed: " . $insert_stmt->error]);
                exit;
            }
            $insert_stmt->close();
        }
        $check_stmt->close();
    } else {
        $insert_stmt = $conn->prepare("INSERT INTO tbl_question (section, question, type, status, required, survey_title, header, transaction_type, question_rendering) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $insert_stmt->bind_param("sssisssis", $section, $question_text, $type, $survey_status, $required, $survey_title, $header, $transaction_type_str, $render);
        if (!$insert_stmt->execute()) {
            echo json_encode(["error" => "Insert failed: " . $insert_stmt->error]);
            exit;
        }
        $insert_stmt->close();
    }

    if (isset($question['choices']) && is_array($question['choices'])) {
        $question_id_stmt = $conn->prepare("SELECT id FROM tbl_question WHERE question = ? AND survey_title = ?");
        $question_id_stmt->bind_param("ss", $question_text, $survey_title);
        $question_id_stmt->execute();
        $question_id_result = $question_id_stmt->get_result();
        if ($q_row = $question_id_result->fetch_assoc()) {
            $question_id = $q_row['id'];

            $conn->query("DELETE FROM tbl_choices WHERE question_id = $question_id");

            foreach ($question['choices'] as $choice) {
                $choice_text = $choice['choice_text'];
                $choice_stmt = $conn->prepare("INSERT INTO tbl_choices (question_id, choice_text) VALUES (?, ?)");
                $choice_stmt->bind_param("is", $question_id, $choice_text);
                if (!$choice_stmt->execute()) {
                    echo json_encode(["error" => "Choice insert failed: " . $choice_stmt->error]);
                    exit;
                }
                $choice_stmt->close();
            }
        }
        $question_id_stmt->close();
    }
}

foreach ($deletedQuestions as $del) {
    $del_section = $del['section'];
    $del_question = $del['question'];

    $delete_stmt = $conn->prepare("DELETE FROM tbl_question WHERE section = ? AND question = ?");
    $delete_stmt->bind_param("ss", $del_section, $del_question);
    if (!$delete_stmt->execute()) {
        echo json_encode(["error" => "Delete failed: " . $delete_stmt->error]);
        exit;
    }
    $delete_stmt->close();
}

echo json_encode([
    "message" => "Survey updated successfully.",
    "survey_title" => $survey_title
]);
