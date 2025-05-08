<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $campus_name = $_POST['campus'];


    $conn->begin_transaction();

    try {

        $sql_choices = "DELETE FROM tbl_choices WHERE choice_text = ?";
        $stmt_choices = $conn->prepare($sql_choices);
        $stmt_choices->bind_param("s", $campus_name);
        $stmt_choices->execute();
        $stmt_choices->close();


        $sql_campus = "DELETE FROM tbl_campus WHERE campus = ?";
        $stmt_campus = $conn->prepare($sql_campus);
        $stmt_campus->bind_param("s", $campus_name);
        $stmt_campus->execute();
        $stmt_campus->close();


        $conn->commit();
        echo json_encode(["success" => true]);
    } catch (Exception $e) {

        $conn->rollback();
        echo json_encode(["success" => false, "error" => $e->getMessage()]);
    }

    $conn->close();
}
