<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$database = "db_css";
$username = "root";
$password = "";
$host = "localhost";

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]);
    exit;
}

date_default_timezone_set('Asia/Manila');
$backupTimestamp = date("Y-m-d H:i"); // Get current timestamp up to the minute
$backupFile = "{$database}_backup_" . date("Y-m-d_H-i") . ".sql";
$backupPath = __DIR__ . DIRECTORY_SEPARATOR . "backups" . DIRECTORY_SEPARATOR . $backupFile;

if (!is_dir(__DIR__ . "/backups")) {
    mkdir(__DIR__ . "/backups", 0777, true);
}

// Check if a backup with the same minute already exists in the backup_date column
$stmtCheck = $conn->prepare("SELECT COUNT(*) FROM tbl_backups WHERE DATE_FORMAT(backup_date, '%Y-%m-%d %H:%i') = ?");
$stmtCheck->bind_param("s", $backupTimestamp);
$stmtCheck->execute();
$stmtCheck->bind_result($count);
$stmtCheck->fetch();
$stmtCheck->close();

if ($count > 0) {
    // A backup with the same minute already exists
    echo json_encode([
        "status" => "warning",
        "message" => "Backup with the same minute already exists: $backupTimestamp"
    ]);
    $conn->close();
    exit;
}

// If no existing backup with the same minute, proceed with backup
$command = "C:\\xampp\\mysql\\bin\\mysqldump --user=$username --password=$password --host=$host --result-file=$backupPath $database";
exec($command, $output, $result);

if ($result === 0 && file_exists($backupPath)) {
    // Backup successful, now store the path in the database, including the timestamp
    $mysqlTimestamp = date("Y-m-d H:i:s"); // Get the full second timestamp for database insertion.
    $stmt = $conn->prepare("INSERT INTO tbl_backups (backup_file_name, backup_file_path, backup_date) VALUES (?, ?, ?)");
    if ($stmt === false) {
        echo json_encode(["status" => "error", "message" => "Failed to prepare SQL statement: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("sss", $backupFile, $backupPath, $mysqlTimestamp);
    if (!$stmt->execute()) {
        echo json_encode(["status" => "error", "message" => "Error saving backup path to database: " . $stmt->error]);
        exit;
    }

    // Return success message with backup details
    echo json_encode([
        "status" => "success",
        "message" => "Backup successful! File created: $backupFile",
        "backup_file" => $backupFile,
        "backup_path" => $backupPath,
        "backup_date" => $mysqlTimestamp,
    ]);

    $stmt->close();
} else {
    // Backup failed
    echo json_encode([
        "status" => "error",
        "message" => "Backup failed. Result code: $result"
    ]);
}

$conn->close();
