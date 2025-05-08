<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$old_customer_type = $_POST['old_customer_type'];
$new_customer_type = $_POST['new_customer_type'];

$response = array();

$stmt = $conn->prepare("SELECT * FROM tbl_customer_type WHERE customer_type = ?");
$stmt->bind_param("s", $new_customer_type);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $response['success'] = false;
    $response['error'] = 'Customer type already exists';
} else {
    $conn->begin_transaction();

    try {

        $stmt1 = $conn->prepare("UPDATE tbl_customer_type SET customer_type = ? WHERE customer_type = ?");
        $stmt1->bind_param("ss", $new_customer_type, $old_customer_type);
        $customer_result = $stmt1->execute();

        $stmt2 = $conn->prepare("UPDATE tbl_choices SET choice_text = ? WHERE choice_text = ?");
        $stmt2->bind_param("ss", $new_customer_type, $old_customer_type);
        $choices_result = $stmt2->execute();

        if ($customer_result && $choices_result) {
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
