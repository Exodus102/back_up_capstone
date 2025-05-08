<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json");

require '../db_connection.php';

$response = [];

if (isset($_FILES['file']) && $_FILES['file']['error'] == 0) {
    $filename = $_FILES['file']['tmp_name'];
    $file = fopen($filename, "r");

    // Skip the header row
    fgetcsv($file);

    $successCount = 0;
    $failCount = 0;

    while (($data = fgetcsv($file, 1000, ",")) !== FALSE) {
        $question_id = $conn->real_escape_string($data[0]);
        $original_response_id = (int) $conn->real_escape_string($data[1]);
        $response_txt = $conn->real_escape_string($data[2]);
        $comment = $conn->real_escape_string($data[3]);
        $analysis = $conn->real_escape_string($data[4]);
        $timestamp = $conn->real_escape_string($data[5]);
        $header = $conn->real_escape_string($data[6]);
        $transaction_type = $conn->real_escape_string($data[7]);
        $question_rendering = $conn->real_escape_string($data[8]);

        // Check if response_id and response already exist
        $response_id = $original_response_id;
        while (true) {
            $checkQuery = "SELECT * FROM tbl_responses WHERE response_id = '$response_id' AND response = '$response_txt'";
            $checkResult = $conn->query($checkQuery);
            if ($checkResult && $checkResult->num_rows > 0) {
                // If exists, increment response_id and check again
                $response_id++;
            } else {
                // If not exists, break the loop and use this response_id
                break;
            }
        }

        $sql = "INSERT INTO tbl_responses 
            (question_id, response_id, response, comment, analysis, timestamp, header, transaction_type, question_rendering) 
            VALUES 
            ('$question_id', '$response_id', '$response_txt', '$comment', '$analysis', '$timestamp', '$header', '$transaction_type', '$question_rendering')";

        if ($conn->query($sql)) {
            $successCount++;
        } else {
            $failCount++;
        }
    }


    fclose($file);

    echo json_encode([
        "status" => "success",
        "message" => "File processed successfully.",
        "inserted" => $successCount,
        "failed" => $failCount
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No file uploaded or file upload error."
    ]);
}
