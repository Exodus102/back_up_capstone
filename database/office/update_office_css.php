<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents("php://input"));

$campus = $data->campus ?? '';
$oldOffice = $data->old_office ?? '';
$newOffice = $data->new_office ?? '';

if (!$campus || !$oldOffice || !$newOffice) {
    echo json_encode(["success" => false, "message" => "Invalid input"]);
    exit;
}

$checkSql = "SELECT * FROM tbl_office WHERE office = ? AND campus = ?";
$checkStmt = $conn->prepare($checkSql);
$checkStmt->bind_param("ss", $newOffice, $campus);
$checkStmt->execute();
$checkResult = $checkStmt->get_result();

if ($checkResult->num_rows > 0) {

    echo json_encode(["success" => false, "message" => "Office name already exists in this campus."]);
    exit;
}

$sql = "UPDATE tbl_office SET office = ? WHERE office = ? AND campus = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sss", $newOffice, $oldOffice, $campus);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "message" => $stmt->error]);
}
