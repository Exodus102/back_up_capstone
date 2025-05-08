<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

require '../phpmailer/vendor/autoload.php';
require '../db_connection.php';

if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit();
}


$email = $_POST['email'] ?? null;

if (!$email) {
    echo json_encode(["error" => "No email provided"]);
    exit();
}


$verification_code = rand(100000, 999999);


$expires_at = date('Y-m-d H:i:s', strtotime('+5 minutes'));


$account_stmt = $conn->prepare("SELECT id, fname FROM tbl_account WHERE email = ?");
$account_stmt->bind_param("s", $email);
$account_stmt->execute();
$account_stmt->bind_result($account_id, $firstname);
$account_stmt->fetch();
$account_stmt->close();

if (!$account_id) {
    echo json_encode(["error" => "Email not found in tbl_account."]);
    exit();
}


$stmt = $conn->prepare("INSERT INTO verification_code (account_id, email, code, expires_at) VALUES (?, ?, ?, ?)");
$stmt->bind_param("isss", $account_id, $email, $verification_code, $expires_at);
$stmt->execute();
$stmt->close();


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
    $mail->addAddress($email);

    $mail->isHTML(true);
    $mail->Subject = 'Your Verification Code';


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
                padding: 5px;
                text-align: center;
                color: white;
                font-size: 22px;
                font-weight: 600;
                gap: 8px;
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
            .code {
                background: #f4f4f4;
                display: inline-block;
                padding: 10px 20px;
                font-size: 24px;
                font-weight: bold;
                border-radius: 5px;
                margin-top: 10px;
                font-family: "Poppins", sans-serif;
            }
            .footer {
                background: #f8f8f8;
                padding: 15px;
                text-align: center;
                font-size: 12px;
                color: #777;
            }
            .warning {
                margin-top: 15px;
                font-size: 14px;
                color: white;
                background: #ff4d4d;
                padding: 10px;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <div class="email-container">
            <div class="header">
                <img src="https://i.ibb.co/kV4Ddtnp/Logo.png" class="logo" alt="Logo">
                <p>CSS Account Verification</p>
            </div>
            <div class="content">
                <p>Hello <b>' . htmlspecialchars($firstname) . '</b>,</p>
                <p>Your verification code is:</p>
                <div class="code">' . htmlspecialchars($verification_code) . '</div>
                <p>This code will expire in <b>5 minutes</b>.</p>
                <div class="warning">
                    If you did not request this code, please disregard this email.
                </div>
            </div>
            <div class="footer">
            <p>We comply so URSatisfied.</p>
                &copy; ' . date('Y') . ' CSS Web. All rights reserved.
            </div>
        </div>
    </body>
    </html>';


    $mail->send();
    echo json_encode(["success" => "Code sent successfully"]);
} catch (Exception $e) {
    echo json_encode(["error" => "Mailer Error: " . $mail->ErrorInfo]);
}

$conn->close();
