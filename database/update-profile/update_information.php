<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $fname = $_POST['fname'];
    $lname = $_POST['lname'];
    $password = $_POST['password'];

    $updateQuery = "UPDATE tbl_account SET fname=?, lname=?, password=? WHERE email=?";
    $stmt = $conn->prepare($updateQuery);
    $stmt->bind_param("ssss", $fname, $lname, $password, $email);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "User updated successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to update user"]);
    }
    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
