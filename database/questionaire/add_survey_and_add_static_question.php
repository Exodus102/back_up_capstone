<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$currentYear = date("Y");

// Get the latest survey title for the current year
$query = "SELECT survey_title FROM tbl_survey WHERE survey_title LIKE '$currentYear%_Questionnaire%' ORDER BY survey_title DESC LIMIT 1";
$result = mysqli_query($conn, $query);
$row = mysqli_fetch_assoc($result);

// Check if version exists
function checkIfVersionExists($surveyTitle, $conn)
{
    $query = "SELECT COUNT(*) FROM tbl_survey WHERE survey_title = '$surveyTitle'";
    $result = mysqli_query($conn, $query);
    $count = mysqli_fetch_row($result)[0];
    return $count > 0;
}

// Determine version
if ($row) {
    preg_match('/v(\d+)\.(\d+)/', $row['survey_title'], $matches);
    if ($matches) {
        $majorVersion = (int)$matches[1];
        $minorVersion = (int)$matches[2];
        $newMinorVersion = $minorVersion + 1;
    } else {
        $majorVersion = 1;
        $newMinorVersion = 2;
    }
    $newVersion = "{$majorVersion}.{$newMinorVersion}";
} else {
    $newVersion = "1.2";
}

$newSurveyTitle = "{$currentYear}_Questionnaire_v{$newVersion}";

// Ensure survey title is unique
if (checkIfVersionExists($newSurveyTitle, $conn)) {
    do {
        $newMinorVersion++;
        $newVersion = "{$majorVersion}.{$newMinorVersion}";
        $newSurveyTitle = "{$currentYear}_Questionnaire_v{$newVersion}";
    } while (checkIfVersionExists($newSurveyTitle, $conn));
}

// Insert new survey
$status = 0;
$insertQuery = "INSERT INTO tbl_survey (survey_title, status) VALUES ('$newSurveyTitle', $status)";
if (mysqli_query($conn, $insertQuery)) {
    // Proceed to insert related questions and choices
    runQuestionScript($conn, $newSurveyTitle);
    //addTransactionTypeQuestion($conn, $newSurveyTitle);

    echo json_encode(["status" => "success", "message" => "Survey created with title: $newSurveyTitle"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error creating survey: " . mysqli_error($conn)]);
}

// -----------------------------
// Question & Choices Logic
// -----------------------------

function runQuestionScript($conn, $surveyTitle)
{
    $questions = [
        "Campus" => ["table" => "tbl_campus", "column" => "campus", "section" => "Section 1"],
        "Division" => ["table" => "tbl_division", "column" => "division", "section" => "Section 1"],
        "Office" => ["table" => "tbl_office_list", "column" => "office", "section" => "Section 1"],
        "Customer Type" => ["table" => "tbl_customer_type", "column" => "customer_type", "section" => "Section 2"]
    ];

    foreach ($questions as $question => $details) {
        // Always insert a new question with status = 0
        $question_id = insertQuestion($conn, $question, $details["section"], $surveyTitle);

        // Insert choices related to the question
        $choices = fetchData($conn, $details["table"], $details["column"]);
        insertChoices($conn, $question_id, $choices);
    }
}

function insertQuestion($conn, $question, $section, $surveyTitle)
{
    // Always insert a new question with status = 0
    $stmt = $conn->prepare("INSERT INTO tbl_question (question, type, required, status, section, survey_title) VALUES (?, 'Dropdown', 1, 0, ?, ?)");
    $stmt->bind_param("sss", $question, $section, $surveyTitle);
    $stmt->execute();

    if ($stmt->error) {
        error_log("Insert Question Error: " . $stmt->error);
    }

    $question_id = $stmt->insert_id;
    $stmt->close();
    return $question_id;
}

function insertChoices($conn, $question_id, $data)
{
    $stmt = $conn->prepare("INSERT INTO tbl_choices (question_id, choice_text) VALUES (?, ?)");
    foreach ($data as $value) {
        $choice_text = (string)$value;
        // Insert each choice only if it doesn't exist already
        if (!getExistingChoice($conn, $question_id, $choice_text)) {
            $stmt->bind_param("is", $question_id, $choice_text);
            $stmt->execute();
        }
    }
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

function addTransactionTypeQuestion($conn, $surveyTitle)
{
    // Insert "Transaction Type" question into tbl_question with status = 0
    $question = "Transaction Type";
    $section = "Section 2";
    $type = "Dropdown";
    $required = 1;
    $status = 0;

    $stmt = $conn->prepare("INSERT INTO tbl_question (question, type, required, status, section, survey_title) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssisss", $question, $type, $required, $status, $section, $surveyTitle);
    $stmt->execute();

    if ($stmt->error) {
        error_log("Insert Transaction Type Question Error: " . $stmt->error);
    }

    $question_id = $stmt->insert_id;
    $stmt->close();

    // Insert choices "Face-to-Face" and "Online" for the "Transaction Type" question
    $choices = ["Face-to-Face", "Online"];
    insertChoices($conn, $question_id, $choices);
}
