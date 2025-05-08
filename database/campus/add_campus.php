<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$campus = $_POST['campus'];


$check_sql = "SELECT * FROM tbl_campus WHERE campus = '$campus'";
$check_result = $conn->query($check_sql);

if ($check_result->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Campus already exists"]);
} else {
    $sql = "INSERT INTO tbl_campus (campus) VALUES ('$campus')";

    if ($conn->query($sql) === TRUE) {
        $last_id = $conn->insert_id;
        $update_sql = "UPDATE tbl_campus SET campus_id = $last_id WHERE id = $last_id";
        if ($conn->query($update_sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "New record created successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $update_sql . "<br>" . $conn->error]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $sql . "<br>" . $conn->error]);
    }
}

$conn->close();
