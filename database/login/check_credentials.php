<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (isset($_POST['email']) && isset($_POST['password'])) {
    $email = $_POST['email'];
    $password = $_POST['password'];
} elseif (isset($data['email']) && isset($data['password'])) {
    $email = $data['email'];
    $password = $data['password'];
} else {
    echo json_encode(["error" => "Email or password not provided"]);
    exit();
}

$query = "SELECT password FROM tbl_account WHERE email = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    if ($password === $row['password']) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "error" => "Incorrect password"]);
    }
} else {
    echo json_encode(["success" => false, "error" => "Email not found"]);
}
