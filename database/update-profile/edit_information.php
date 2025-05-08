<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($conn->connect_error) {
    $errorMessage = "Connection failed: " . $conn->connect_error . " - " . $conn->error;
    die(json_encode(['success' => false, 'message' => $errorMessage]));
}

$email = $_POST['email'];
$password = $_POST['password'];
$fname = $_POST['fname'];
$lname = $_POST['lname'];
$contact = $_POST['contact'];
$campus = $_POST['campus'];
$unit = $_POST['unit'];
$userRole = $_POST['userRole'];
$status = (int)$_POST['status'];

$sql = "UPDATE tbl_account SET 
            password = ?, 
            fname = ?, 
            lname = ?,
            contact_no = ?, 
            campus = ?, 
            unit = ?, 
            user_roles = ?, 
            status = ? 
        WHERE Email = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssssssis", $password, $fname, $lname, $contact, $campus, $unit, $userRole, $status, $email);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Account updated successfully.']);
} else {
    $errorMessage = "Error updating record: " . $stmt->error . " - " . $conn->error;
    echo json_encode(['success' => false, 'message' => $errorMessage]);
}

$stmt->close();
$conn->close();
