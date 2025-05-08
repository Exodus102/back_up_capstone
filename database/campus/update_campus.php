<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$old_campus = $_POST['old_campus'];
$new_campus = $_POST['new_campus'];

$response = array();

$stmt = $conn->prepare("SELECT * FROM tbl_campus WHERE campus = ?");
$stmt->bind_param("s", $new_campus);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $response['success'] = false;
    $response['error'] = 'Campus already exists';
} else {
    $conn->begin_transaction();

    try {

        $stmt1 = $conn->prepare("UPDATE tbl_campus SET campus = ? WHERE campus = ?");
        $stmt1->bind_param("ss", $new_campus, $old_campus);
        $campus_result = $stmt1->execute();


        $stmt2 = $conn->prepare("UPDATE tbl_choices SET choice_text = ? WHERE choice_text = ?");
        $stmt2->bind_param("ss", $new_campus, $old_campus);
        $choices_result = $stmt2->execute();

        if ($campus_result && $choices_result) {
            $conn->commit();
            $response['success'] = true;
        } else {
            throw new Exception("Error updating one or both tables");
        }

        $stmt1->close();
        $stmt2->close();
    } catch (Exception $e) {
        $conn->rollback();
        $response['success'] = false;
        $response['error'] = $conn->error ?: $e->getMessage();
    }
}

$stmt->close();
$conn->close();

echo json_encode($response);
