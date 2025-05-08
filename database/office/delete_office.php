<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$office = $_POST['office'];

$conn->begin_transaction();

try {

    $stmt1 = $conn->prepare("DELETE FROM tbl_office_list WHERE office = ?");
    $stmt1->bind_param("s", $office);
    $office_result = $stmt1->execute();

    $stmt2 = $conn->prepare("DELETE FROM tbl_choices WHERE choice_text = ?");
    $stmt2->bind_param("s", $office);
    $choices_result = $stmt2->execute();

    if ($office_result && $choices_result) {
        $conn->commit();
        echo json_encode(["message" => "Record deleted successfully from both tables"]);
    } else {
        throw new Exception("Error deleting record from one or both tables");
    }

    $stmt1->close();
    $stmt2->close();
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode([
        "error" => "Error deleting record: " . ($conn->error ?: $e->getMessage())
    ]);
}

$conn->close();
