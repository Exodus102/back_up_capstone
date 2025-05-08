<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '../db_connection.php';
require '../phpmailer/vendor/autoload.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header('Access-Control-Allow-Headers: Content-Type');

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

$data = json_decode(file_get_contents("php://input"), true);

if ($data) {
    $email = $data['email'];
    $password = $data['password'];
    $fname = $data['fname'];
    $lname = $data['lname'];
    $contact_no = $data['contact_no'];
    $user_roles = $data['user_roles'];
    $campus = $data['campus'];
    $unit = $data['unit'];
    $status = 1;
    $dp = isset($data['dp']) ? base64_decode($data['dp']) : null;

    $check_stmt = $conn->prepare("SELECT email FROM tbl_account WHERE email = ?");
    $check_stmt->bind_param("s", $email);
    $check_stmt->execute();
    $check_stmt->store_result();

    if ($check_stmt->num_rows > 0) {
        echo json_encode(["success" => false, "message" => "Email already exists"]);
    } else {
        $stmt = $conn->prepare("INSERT INTO tbl_account (email, password, fname, lname, contact_no, user_roles, campus, unit, status, dp)
                                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

        $stmt->bind_param("ssssssssis", $email, $password, $fname, $lname, $contact_no, $user_roles, $campus, $unit, $status, $dp);

        if ($stmt->execute()) {
            sendEmailNotification($email, $password, $fname, $lname);
            echo json_encode(["success" => true, "message" => "Account added successfully and email sent"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $stmt->error]);
        }

        $stmt->close();
    }

    $check_stmt->close();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}

$conn->close();


function sendEmailNotification($email, $password, $fname, $lname)
{
    $mail = new PHPMailer(true);
    try {

        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';
        $mail->SMTPAuth = true;
        $mail->Username = 'dlhor65@gmail.com';
        $mail->Password = 'sohm sakq lvbl yhje';
        $mail->SMTPSecure = 'tls';
        $mail->Port = 587;

        $mail->setFrom('dlhor65@gmail.com', 'URSatisfaction');
        $mail->addAddress($email, "$fname $lname");

        $mail->isHTML(true);
        $mail->Subject = "Your Account Has Been Created!";
        $mail->Body = '
    <!DOCTYPE html>
    <html>
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #1e3c72, #2a5298);
                font-family: "Poppins", sans-serif;
                margin: 0;
                padding: 0;
            }
            .email-container {
                width: 100%;
                max-width: 500px;
                margin: 50px auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }
            .header {
                background: #2a5298;
                padding: 10px;
                text-align: center;
                color: white;
                font-size: 22px;
                font-weight: 600;
            }
            .content {
                padding: 20px;
                text-align: center;
                font-size: 16px;
                background: linear-gradient(135deg, #07326A, #064089);
                border-radius: 0 0 10px 10px;
            }
            .content p {
                color: white;
            }
            .logo {
                max-width: 80px;
                height: auto;
                margin-top: 10px;
            }
            .info-box {
                background: #f4f4f4;
                display: inline-block;
                padding: 10px 20px;
                font-size: 18px;
                font-weight: bold;
                border-radius: 5px;
                margin-top: 10px;
                font-family: "Poppins", sans-serif;
                color: #333;
            }
            .footer {
                background: #f8f8f8;
                padding: 15px;
                text-align: center;
                font-size: 12px;
                color: #777;
            }
        </style>
    </head>
    <body>
        <div class="email-container">
            <div class="header">
                <img src="https://i.ibb.co/kV4Ddtnp/Logo.png" class="logo" alt="Logo">
                <p>Your Account Has Been Created!</p>
            </div>
            <div class="content">
                <p>Hello <b>' . htmlspecialchars($fname) . ' ' . htmlspecialchars($lname) . '</b>,</p>
                <p>We are pleased to inform you that your account has been successfully created.</p>
                <p><b>Your Login Details:</b></p>
                <div class="info-box">
                    Email: ' . htmlspecialchars($email) . '<br>
                    Password: ' . htmlspecialchars($password) . '
                </div>
                <p>Please keep your login credentials secure.</p>
            </div>
            <div class="footer">
                <p>Thank you for being part of our system.</p>
                &copy; ' . date('Y') . ' CSS Web. All rights reserved.
            </div>
        </div>
    </body>
    </html>';


        $mail->send();
    } catch (Exception $e) {
        error_log("Email sending failed: {$mail->ErrorInfo}");
    }
}
