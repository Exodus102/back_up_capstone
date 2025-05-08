<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

function getExistingQuestion($conn, $question)
{
    $stmt = $conn->prepare("SELECT id, status FROM tbl_question WHERE question = ?");
    $stmt->bind_param("s", $question);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    $stmt->close();
    return $row;
}

function insertQuestion($conn, $question, $section)
{
    $stmt = $conn->prepare("INSERT INTO tbl_question (question, type, required, status, section) VALUES (?, 'Dropdown', 1, 1, ?)");
    $stmt->bind_param("ss", $question, $section);
    $stmt->execute();
    $question_id = $stmt->insert_id;
    $stmt->close();
    return $question_id;
}

function updateQuestionStatus($conn, $question_id)
{
    $stmt = $conn->prepare("UPDATE tbl_question SET status = 1 WHERE id = ?");
    $stmt->bind_param("i", $question_id);
    $stmt->execute();
    $stmt->close();
}

function getExistingChoice($conn, $question_id, $choice_text)
{
    $stmt = $conn->prepare("SELECT id FROM tbl_choices WHERE question_id = ? AND choice_text = ?");
    $stmt->bind_param("is", $question_id, $choice_text);
    $stmt->execute();
    $result = $stmt->get_result();
    $exists = $result->num_rows > 0;
    $stmt->close();
    return $exists;
}

function insertChoices($conn, $question_id, $data)
{
    $stmt = $conn->prepare("INSERT INTO tbl_choices (question_id, choice_text) VALUES (?, ?)");
    foreach ($data as $value) {
        $choice_text = (string)$value;
        if (!getExistingChoice($conn, $question_id, $choice_text)) {
            $stmt->bind_param("is", $question_id, $choice_text);
            $stmt->execute();
        }
    }
    $stmt->close();
}

function fetchData($conn, $table, $column)
{
    $data = [];
    $sql = "SELECT $column FROM $table";
    $result = $conn->query($sql);
    while ($row = $result->fetch_assoc()) {
        $data[] = $row[$column];
    }
    return $data;
}

$questions = [
    "Campus" => ["table" => "tbl_campus", "column" => "campus", "section" => "Section 1"],
    "Division" => ["table" => "tbl_division", "column" => "division", "section" => "Section 1"],
    "Office" => ["table" => "tbl_office_list", "column" => "office", "section" => "Section 1"],
    "Customer Type" => ["table" => "tbl_customer_type", "column" => "customer_type", "section" => "Section 2"]
];

foreach ($questions as $question => $details) {
    $existingQuestion = getExistingQuestion($conn, $question);

    if ($existingQuestion) {
        if ($existingQuestion['status'] == 0) {
            updateQuestionStatus($conn, $existingQuestion['id']);
            echo "Updated status of existing question: $question\n";
        } else {
            echo "Question already exists and is active: $question\n";
        }
        $question_id = $existingQuestion['id'];
    } else {
        $question_id = insertQuestion($conn, $question, $details["section"]);
        echo "Inserted new question: $question\n";
    }

    $choices = fetchData($conn, $details["table"], $details["column"]);
    insertChoices($conn, $question_id, $choices);
}

$conn->close();
