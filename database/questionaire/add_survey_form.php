<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$currentYear = date("Y");

// Initial query to find the latest survey title for the current year
$query = "SELECT survey_title FROM tbl_survey WHERE survey_title LIKE '$currentYear%_Questionnaire%' ORDER BY survey_title DESC LIMIT 1";
$result = mysqli_query($conn, $query);
$row = mysqli_fetch_assoc($result);

// Function to check if the version exists in the database
function checkIfVersionExists($surveyTitle, $conn)
{
    $query = "SELECT COUNT(*) FROM tbl_survey WHERE survey_title = '$surveyTitle'";
    $result = mysqli_query($conn, $query);
    $count = mysqli_fetch_row($result)[0];
    return $count > 0;
}

if ($row) {
    // Extract major and minor version numbers from the survey title
    preg_match('/v(\d+)\.(\d+)/', $row['survey_title'], $matches);

    if ($matches) {
        // If versioning is found, increment the minor version
        $majorVersion = (int)$matches[1];  // Major version (int to ensure correct increment)
        $minorVersion = (int)$matches[2];  // Minor version (int to ensure correct increment)
        $newMinorVersion = $minorVersion + 1;  // Increment minor version
    } else {
        // If no versioning is found, assume starting version is 1.2
        $majorVersion = 1;
        $newMinorVersion = 2;
    }

    // Format the new version number properly
    $newVersion = "{$majorVersion}.{$newMinorVersion}";
} else {
    // If no previous survey exists, start with version 1.2
    $newVersion = "1.2";
}

// Construct the new survey title
$newSurveyTitle = "{$currentYear}_Questionnaire_v{$newVersion}";

// Check if the survey title with the new version already exists
if (checkIfVersionExists($newSurveyTitle, $conn)) {
    // If the version already exists, increment the minor version further
    do {
        $newMinorVersion++;
        $newVersion = "{$majorVersion}.{$newMinorVersion}";
        $newSurveyTitle = "{$currentYear}_Questionnaire_v{$newVersion}";
    } while (checkIfVersionExists($newSurveyTitle, $conn)); // Repeat until a unique version is found
}

$status = 0;

// Insert the new survey into the database
$insertQuery = "INSERT INTO tbl_survey (survey_title, status) VALUES ('$newSurveyTitle', $status)";
if (mysqli_query($conn, $insertQuery)) {
    echo json_encode(["status" => "success", "message" => "Survey created successfully with title: $newSurveyTitle"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error creating survey: " . mysqli_error($conn)]);
}
