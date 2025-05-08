<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['email'])) {
    $email = $data['email'];
    $sql = "SELECT fname, dp FROM tbl_account WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $imageBase64 = base64_encode($row['dp']);
            echo json_encode([
                'status' => 'found',
                'fname' => $row['fname'],
                'image' => $imageBase64
            ]);
        } else {
            echo json_encode(['status' => 'not_found', 'message' => 'No user found']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database query failed']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Email is required']);
}
