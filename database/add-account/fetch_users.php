<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Get filter values from the request
$campus = isset($_GET['campus']) ? $_GET['campus'] : '';
$unit = isset($_GET['unit']) ? $_GET['unit'] : '';
$userType = isset($_GET['user_type']) ? $_GET['user_type'] : '';
$status = isset($_GET['status']) ? $_GET['status'] : '';
$dateCreated = isset($_GET['created_at']) ? $_GET['created_at'] : '';
$searchQuery = isset($_GET['search']) ? $_GET['search'] : ''; // Get search input

// Construct the SQL query with filters
$sql = "SELECT id, email, fname, lname, contact_no, user_roles, campus, created_at, status, password, unit 
        FROM tbl_account 
        WHERE 1=1";

// Apply filters
if (!empty($campus)) {
    $sql .= " AND campus = '" . $conn->real_escape_string($campus) . "'";
}
if (!empty($unit)) {
    $sql .= " AND unit = '" . $conn->real_escape_string($unit) . "'";
}
if (!empty($userType) && $userType != 'Show All') {
    $sql .= " AND user_roles = '" . $conn->real_escape_string($userType) . "'";
}
if (!empty($status) && $status != 'Show All') {
    $sql .= " AND status = '" . ($status == 'Active' ? 1 : 0) . "'";
}
if (!empty($dateCreated)) {
    $sql .= " AND DATE(created_at) = '" . $conn->real_escape_string($dateCreated) . "'";
}

// Add search functionality
if (!empty($searchQuery)) {
    $searchQuery = $conn->real_escape_string($searchQuery);
    $sql .= " AND (fname LIKE '%$searchQuery%' OR lname LIKE '%$searchQuery%' OR email LIKE '%$searchQuery%')";
}

$result = $conn->query($sql);

$users = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $users[] = [
            "Campus" => $row["campus"],
            "Unit" => $row["unit"],
            "User Type" => $row["user_roles"],
            "Name" => $row["fname"] . " " . $row["lname"],
            "Contact Number" => $row["contact_no"],
            "Email" => $row["email"],
            "Password" => $row["password"],
            "Date Created" => date("Y-m-d", strtotime($row["created_at"])),
            "Status" => $row["status"] == 1 ? "Active" : "Inactive",
        ];
    }
}

$conn->close();
echo json_encode($users);
