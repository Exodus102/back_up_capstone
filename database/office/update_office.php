<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$old_unit = $_POST['old_unit'];
$new_unit = $_POST['new_unit'];

$response = array();

$stmt = $conn->prepare("SELECT * FROM tbl_office_list WHERE office = ?");
$stmt->bind_param("s", $new_unit);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $response['success'] = false;
    $response['error'] = 'Unit already exists';
} else {
    $conn->begin_transaction();

    try {

        $stmt1 = $conn->prepare("UPDATE tbl_office_list SET office = ? WHERE office = ?");
        $stmt1->bind_param("ss", $new_unit, $old_unit);
        $office_result = $stmt1->execute();

        $stmt2 = $conn->prepare("UPDATE tbl_choices SET choice_text = ? WHERE choice_text = ?");
        $stmt2->bind_param("ss", $new_unit, $old_unit);
        $choices_result = $stmt2->execute();

        if ($office_result && $choices_result) {
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
