<?php
require('../fpdf186/fpdf.php');
require('../db_connection.php');
require('../FPDI-2.6.3/src/autoload.php');
require('create_table-copy.php');
require('office_list.php');

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

use setasign\Fpdi\Fpdi;

class PDF extends FPDI
{
    function Footer()
    {
        $this->SetFont('ArialNarrow', '', 10);
        $this->SetY(-23.5);

        global $quarter, $year, $campus;

        $quarterText = [
            '1st Quarter CSS Report' => 'January to March',
            '2nd Quarter CSS Report' => 'April to June',
            '3rd Quarter CSS Report' => 'July to September',
            '4th Quarter CSS Report' => 'October to December'
        ];

        $quarterLabel = $quarterText[$quarter] ?? "January to March";
        $quarterText = "$quarterLabel $year";
        $campusText = "URS " . strtoupper($campus) . " CAMPUS";

        $pageWidth = $this->GetPageWidth();


        $campusTextWidth = $this->GetStringWidth($campusText);
        $quarterTextWidth = $this->GetStringWidth($quarterText);
        $maxWidth = max($campusTextWidth, $quarterTextWidth);


        $xPosition = $pageWidth - $maxWidth - 24;


        $this->SetX($xPosition);
        $this->SetFont('ArialNarrow', '', 10);
        $this->Cell($maxWidth, 5, $campusText, 0, 1, 'R');


        $this->SetY($this->GetY() - 1.5);


        $this->SetX($xPosition);
        $this->SetFont('ArialNarrow', '', 10);
        $this->Cell($maxWidth, 5, $quarterText, 0, 1, 'R');
    }
}

$year = isset($_POST['year']) ? $_POST['year'] : date("Y");
$quarter = isset($_POST['quarter']) ? $_POST['quarter'] : "1st Quarter CSS Report";
$name = isset($_POST['name']) ? $_POST['name'] : "Unknown";
$campus = isset($_POST['campus']) ? $_POST['campus'] : "Unknown Campus";

$uploadDir = "../uploads/";
$fileName = "{$campus}_report_{$year}_{$quarter}.pdf";
$filePath = $uploadDir . $fileName;

$pdf = new PDF();
$pdf->setSourceFile('../template-pdf/CSS-Report-Template.pdf');
$templateId = $pdf->importPage(1);
$pdf->AddPage();
$pdf->useTemplate($templateId);

$pdf->AddFont('ArialNarrow', '', 'ARIALNB.php');
$pdf->AddFont('BookmanOldStyle', '', 'BookmanOldStyleBold.php');
$pdf->SetFont('BookmanOldStyle', '', 26);

$pageWidth = $pdf->GetPageWidth();
$pageHeight = $pdf->GetPageHeight();

$newText = strtoupper(str_replace("CSS REPORT", "", strtoupper($quarter)));
$textWidth = $pdf->GetStringWidth($newText);
$newTextY = ($pageHeight / 2) - 20;
$newTextX = ($pageWidth - $textWidth) / 2;

$pdf->SetXY($newTextX, $newTextY);
$pdf->Cell($textWidth, 12, $newText, 0, 1);

$quarterText = [
    '1st Quarter CSS Report' => 'January to March',
    '2nd Quarter CSS Report' => 'April to June',
    '3rd Quarter CSS Report' => 'July to September',
    '4th Quarter CSS Report' => 'October to December'
];

$quarterLabel = $quarterText[$quarter] ?? 'January to March';

$nextLineText = strtoupper("$quarterLabel $year");
$nextLineWidth = $pdf->GetStringWidth($nextLineText);
$nextLineX = ($pageWidth - $nextLineWidth) / 2;

$pdf->SetXY($nextLineX, $newTextY + 12);
$pdf->Cell($nextLineWidth, 12, $nextLineText, 0, 1);

$ursText = "URS " . strtoupper($campus);
$ursWidth = $pdf->GetStringWidth($ursText);
$ursX = ($pageWidth - $ursWidth) / 2;

$pdf->SetXY($ursX, $newTextY + 50);
$pdf->Cell($ursWidth, 12, $ursText, 0, 1);


$templateId2 = $pdf->importPage(2);
$pdf->AddPage();
$pdf->useTemplate($templateId2);


$templateId2 = $pdf->importPage(3);
$pdf->AddPage();
$pdf->useTemplate($templateId2);


$page4Id = $pdf->importPage(4);
$pdf->AddPage();
$pdf->useTemplate($page4Id);

addContentToPage4($pdf, $quarter, $year, $ursText, $conn, $name, $campus);

function addNewPageWithBlank($pdf, $page4Id)
{
    $pdf->AddPage();
    $pdf->useTemplate($page4Id);
}

$officeQuery = "SELECT office FROM tbl_office WHERE campus = ?";
$stmt = $conn->prepare($officeQuery);
$stmt->bind_param("s", $campus);
$stmt->execute();
$result = $stmt->get_result();

while ($row = $result->fetch_assoc()) {
    $officeName = $row['office'];
    addOfficeList($pdf, $page4Id, $quarter, $year, $campus, $conn, $officeName);
}

$stmt->close();

$pdf->Output('F', $filePath);

$stmt = $conn->prepare("UPDATE tbl_quarter_report SET file_path = ? WHERE year = ? AND quarter_report = ? AND campus = ?");
$stmt->bind_param("ssss", $filePath, $year, $quarter, $campus);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(["status" => "success", "message" => "File path updated successfully.", "file_path" => $filePath]);
} else {
    echo json_encode(["status" => "error", "message" => "No records updated. Check if the record exists."]);
}


$stmt->close();
$conn->close();
