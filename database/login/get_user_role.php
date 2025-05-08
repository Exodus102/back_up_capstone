<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../db_connection.php';

$response = array();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = isset($_POST['email']) ? $_POST['email'] : '';

    if (!empty($email)) {
        $email = mysqli_real_escape_string($conn, $email);

        $query = "SELECT fname, lname, campus, user_roles, dp, password, unit FROM tbl_account WHERE email = '$email' LIMIT 1";
        $result = mysqli_query($conn, $query);

        if ($result && mysqli_num_rows($result) > 0) {
            $row = mysqli_fetch_assoc($result);
            $userRole = $row['user_roles'];

            $response['email'] = $email;
            $response['fname'] = $row['fname'];
            $response['lname'] = $row['lname'];
            $response['campus'] = $row['campus'];
            $response['password'] = $row['password'];
            $response['unit'] = $row['unit'];

            if (!empty($row['dp'])) {
                $response['dp'] = base64_encode($row['dp']);
            } else {
                $response['dp'] = null;
            }

            if ($userRole === 'University MIS') {
                $response['redirect'] = 'MisPage';
            } elseif ($userRole === 'Coordinators') {
                $response['redirect'] = 'CssCoordinatorPanelSide';
            } elseif ($userRole === 'Director') {
                $response['redirect'] = 'DirectorPanel';
            } elseif ($userRole === 'DCC') {
                $response['redirect'] = 'DccPanel';
            } elseif ($userRole === 'Unit Head') {
                $response['redirect'] = 'UnitHeadPanel';
            } elseif ($userRole === 'CSS Head') {
                $response['redirect'] = 'CssHeadPanel';
            } else {
                $response['error'] = 'Invalid role';
            }
        }


        mysqli_close($conn);
    } else {
        $response['error'] = 'Missing email parameter';
    }
} else {
    $response['error'] = 'Invalid request method';
}

echo json_encode($response);
