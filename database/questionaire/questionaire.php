<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';

$data = json_decode(file_get_contents('php://input'), true);
if (is_array($data)) {
    $campus = $data['campus'] ?? null;
    $division = $data['division'] ?? null;
    $officeUnit = $data['officeUnit'] ?? null;
    $customerType = $data['customerType'] ?? null;
    $name = $data['name'] ?? null;
    $contactNumber = $data['contactNumber'] ?? null;
    $transactionType = $data['transactionType'] ?? null;
    $purposeOfVisit = $data['purposeOfVisit'] ?? null;
    $selectedValues = $data['selectedValues'] ?? [];
    $selectedValuesPage5 = $data['selectedValuesPage5'] ?? [];
    $comments = $data['comments'] ?? null;
    $sentiment = $data['sentiment'];
    $sql = "INSERT INTO tbl_response (campus, division, officeUnit, customerType, name, contactNumber, transactionType, purposeOfVisit, 
                                           rating_a, rating_b, rating_c, rating_d, rating_e, rating_f, rating_g,
                                           page5_rating_1, page5_rating_2, page5_rating_3, page5_rating_4,
                                           comments, analysis)
            VALUES ('$campus', '$division', '$officeUnit', '$customerType', '$name', '$contactNumber', '$transactionType', '$purposeOfVisit', 
                    '{$selectedValues[0]}', '{$selectedValues[1]}', '{$selectedValues[2]}', '{$selectedValues[3]}', '{$selectedValues[4]}', 
                    '{$selectedValues[5]}', '{$selectedValues[6]}',
                    '{$selectedValuesPage5[0]}', '{$selectedValuesPage5[1]}', '{$selectedValuesPage5[2]}', '{$selectedValuesPage5[3]}',
                    '$comments', '$sentiment')";
    if (mysqli_query($conn, $sql)) {
        echo json_encode(['success' => true, 'message' => 'Survey data saved successfully!']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Error: ' . mysqli_error($conn)]);
    }
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid JSON data']);
}
