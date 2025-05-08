<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Database credentials
$host = "localhost";
$username = "root"; // replace with your actual username
$password = "";     // replace with your actual password
$database = "db_css"; // your database name

// Get the JSON body
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['backup_file_name'])) {
    echo json_encode(["status" => "error", "message" => "No backup file name provided."]);
    exit;
}

$filename = basename($data['backup_file_name']); // Prevent directory traversal
$filePath = __DIR__ . "/backups/$filename";

// Check if file exists
if (!file_exists($filePath)) {
    echo json_encode(["status" => "error", "message" => "Backup file not found: $filename"]);
    exit;
}

// Restore command
$command = "C:\\xampp\\mysql\\bin\\mysql --user=$username --password=$password --host=$host $database < \"$filePath\"";

// Execute command
exec($command, $output, $result);

// Response
if ($result === 0) {
    echo json_encode(["status" => "success", "message" => "Database restored from: $filename"]);
} else {
    echo json_encode(["status" => "error", "message" => "Restore failed. Code: $result", "output" => $output]);
}
