<?php
require('../fpdf186/fpdf.php');
require('../FPDI-2.6.3/src/autoload.php');
require('../db_connection.php');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

$campus = isset($_GET['campus']) ? $_GET['campus'] : 'Unknown';
$office = isset($_GET['office']) ? $_GET['office'] : 'Unknown';

use setasign\Fpdi\Fpdi;

$pdf = new FPDI();

$pageCount = $pdf->setSourceFile("../template-pdf/NCAR-Form-template.pdf");

$templateId = $pdf->importPage(1);

$pdf->AddPage();
$pdf->useTemplate($templateId);

$pdf->SetFont('Arial', '', 10);
$pdf->SetTextColor(0, 0, 0);

$pdf->SetLineWidth(0.8);
$pdf->Line(20, 45, 190, 45);
$pdf->SetLineWidth(0.8);

$pdf->SetFont('Arial', 'B', 12.5);

$text = "NON-CONFORMITY and CORRECTIVE ACTION REPORT (NCAR)";
$textWidth = $pdf->GetStringWidth($text);
$x = (210 - $textWidth) / 2;
$pdf->SetXY($x, 50);
$pdf->Write(5, $text);

$pdf->SetFont('Arial', '', 10);

$pdf->SetXY(20, 60);
$pdf->Write(5, "NCAR No.: Automated");

$pdf->SetXY(120, 60);
$pdf->Write(5, "Date: " . date("Y-m-d"));

$pdf->SetLineWidth(0.2);

$pdf->SetFont('Arial', 'B', 10);

$unitData = "Unit: " . $office . "\nSection Clause No. (for IQA only):";

$lineHeight = 5;

$numberOfLines = ceil($pdf->GetStringWidth($unitData) / 170);
$totalHeight = $lineHeight * $numberOfLines;

$pdf->SetXY(20, 70);
$pdf->MultiCell(170, $lineHeight, $unitData, 1, 'L', false);

$checkboxData = "1. Details: \t\t\tNon-conformity raised as a result of:\n" .
    "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Material, Product or Equipment   \t\t\t\t\t\t\t[   ] Unmet Quality Objectives\n" .
    "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Customer Complaints  \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Service Non-conformity\n" .
    "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Internal Quality Audit   \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Improvement\n" .
    "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Clientele Satisfaction Survey   \t\t\t\t\t\t\t\t\t\t\t[   ] Others";

$numberOfLinesCheckbox = ceil($pdf->GetStringWidth($checkboxData) / 170);
$totalHeightCheckbox = $lineHeight * $numberOfLinesCheckbox;
$pdf->SetFont('Arial', '', 10);

$pdf->SetXY(20, 75 + $totalHeight);
$pdf->MultiCell(170, $lineHeight, $checkboxData, 1, 'L', false);

$query = "
    SELECT DISTINCT r.response_id, r.comment, r.analysis
    FROM tbl_responses r
    WHERE r.analysis = 'negative'
    AND r.comment IS NOT NULL
    AND r.comment != ''
    AND r.response_id IN (
        SELECT response_id
        FROM tbl_responses
        WHERE LOWER(response) LIKE '%$office%'
    )
    AND r.response_id IN (
        SELECT response_id
        FROM tbl_responses
        WHERE LOWER(response) LIKE '%$campus%'
    );
";

$result = $conn->query($query);

$comments = '';
if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $comments .= $row['comment'] . "\n";
    }
} else {
    $comments = "No negative comments found.";
}

// Data for the third cell (Description)
$descriptionData = "2. Description of:  \t\t\t[   ] Non-Conformity          [   ] Improvement\n" .
    $comments . "Directed by:" . "\t\t\t\t\t\t\t\t\t\t\t\tDate: ";

// Calculate the height for the third cell dynamically
$descriptionLines = explode("\n", $descriptionData);
$numberOfLinesDescription = count($descriptionLines); // Count actual lines
$totalHeightDescription = $lineHeight * $numberOfLinesDescription;

// Calculate Y position for section 3 dynamically
$yPositionForSection3 = 75 + $totalHeight + $totalHeightCheckbox + 5; // Adjust based on previous sections' height

// Third cell - Position UNDER the second cell (CORRECTED Y-coordinate)
$pdf->SetXY(20, $yPositionForSection3);
$pdf->MultiCell(170, $lineHeight, $descriptionData, 1, 'L', false);

// Calculate the exact height used by MultiCell (this is more accurate)
$actualHeightUsed = $numberOfLinesDescription * $lineHeight;
$newYPosition = $yPositionForSection3 + $actualHeightUsed;

// Fourth cell data
$fourthCellData = "3. Disposition: [Applicable for Material/Product or Equipment only]\n" .
    "\t\t\t\t\t\t\t\t\t\t\t\t[   ] Rework/Repair\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] N/A\n" .
    "\t\t\t\t\t\t\t\t\t\t\t\t[   ] Reject & return to supplier        [   ] Other\n" . "Proposed by:                                Date: ";

// Calculate the height for the fourth cell
$fourthCellLines = explode("\n", $fourthCellData);
$numberOfLinesFourthCell = count($fourthCellLines);
$totalHeightFourthCell = $lineHeight * $numberOfLinesFourthCell;

// Set the Y position and display the fourth cell dynamically below the third cell
$pdf->SetXY(20, $newYPosition);
$pdf->MultiCell(170, $lineHeight, $fourthCellData, 1, 'L', false);

// Calculate position for fifth cell (after fourth cell)
$actualHeightUsedFourth = $numberOfLinesFourthCell * $lineHeight;
$newYPositionFifth = $newYPosition + $actualHeightUsedFourth; // Adding space after fourth cell

$fifthCellData = "4. [   ] Correction (Immediate Action): \t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Not Applicable\n\nResponsible Person/s:                                Date: ";

// Calculate the height for the fifth cell
$fifthCellLines = explode("\n", $fifthCellData);
$numberOfLinesFifthCell = count($fifthCellLines);
$totalHeightFifthCell = $lineHeight * $numberOfLinesFifthCell;

// Set the Y position and display the fifth cell dynamically below the fourth cell
$pdf->SetXY(20, $newYPositionFifth);
$pdf->MultiCell(170, $lineHeight, $fifthCellData, 1, 'L', false);

// Calculate position for sixth cell (after fifth cell)
$actualHeightUsedFifth = $numberOfLinesFifthCell * $lineHeight;
$newYPositionSixth = $newYPositionFifth + $actualHeightUsedFifth; // Adding space after fifth cell

$sixthCellData = "5. Root Cause Analysis: [   ] Non-conformity \t\t\t\t[   ] Not Applicable\n\nInvestigated by:                                Date:\n\nConforme:                                Date: ";

// Calculate the height for the sixth cell
$sixthCellLines = explode("\n", $sixthCellData);
$numberOfLinesSixthCell = count($sixthCellLines);
$totalHeightSixthCell = $lineHeight * $numberOfLinesSixthCell;

// Set the Y position and display the sixth cell dynamically below the fifth cell
$pdf->SetXY(20, $newYPositionSixth);
$pdf->MultiCell(170, $lineHeight, $sixthCellData, 1, 'L', false);

$actualHeightUsedSixth = $numberOfLinesSixthCell * $lineHeight;
$newYPositionSeventh = $newYPositionSixth + $actualHeightUsedSixth; // Adding space after sixth cell

// Seventh cell data - Corrective Action Plan
$seventhCellData = "6. [   ] Corrective Action: \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[   ] Improvement\n\nResponsible:                                Date: ";

// Calculate the height for the seventh cell
$seventhCellLines = explode("\n", $seventhCellData);
$numberOfLinesSeventhCell = count($seventhCellLines);
$totalHeightSeventhCell = $lineHeight * $numberOfLinesSeventhCell;

// Set the Y position and display the seventh cell dynamically below the sixth cell
$pdf->SetXY(20, $newYPositionSeventh);
$pdf->MultiCell(170, $lineHeight, $seventhCellData, 1, 'L', false);

$actualHeightUsedSeventh = $numberOfLinesSeventhCell * $lineHeight;
$newYPositionEighth = $newYPositionSeventh + $actualHeightUsedSeventh; // Adding space after seventh cell

// Eighth cell data - Verification and Closure
$eighthCellData = "7. Follow-up Implementation of Action:\n[   ] Satisfactory Remarks:                                [   ] Not satisfactory\nName & Signature:                                Date: ";

// Calculate the height for the eighth cell
$eighthCellLines = explode("\n", $eighthCellData);
$numberOfLinesEighthCell = count($eighthCellLines);
$totalHeightEighthCell = $lineHeight * $numberOfLinesEighthCell;

// Set the Y position and display the eighth cell dynamically below the seventh cell
$pdf->SetXY(20, $newYPositionEighth);
$pdf->MultiCell(170, $lineHeight, $eighthCellData, 1, 'L', false);

$actualHeightUsedEighth = $numberOfLinesEighthCell * $lineHeight;
$newYPositionNinth = $newYPositionEighth + $actualHeightUsedEighth;

// Ninth cell data - Verification
$ninthCellData = "8. Verification on the effectiveness of action:\n" .
    "To be completed by the ISO Chairperson or Unit Head\n" .
    "[   ] Satisfactory                                [   ] Not satisfactory (issue new NCAR)\n" .
    "Remarks:\n\n" .
    "Verified by: _______________ Print Name _______________ Signature _______________ Date";

$ninthCellLines = explode("\n", $ninthCellData);
$numberOfLinesNinthCell = count($ninthCellLines);
$totalHeightNinthCell = $lineHeight * $numberOfLinesNinthCell;

// Check page break before adding ninth cell
if ($newYPositionNinth + $totalHeightNinthCell > 280) { // Near bottom of A4 page
    $pdf->AddPage();
    $newYPositionNinth = 20; // Reset to top of new page
}

$pdf->SetXY(20, $newYPositionNinth);
$pdf->MultiCell(170, $lineHeight, $ninthCellData, 1, 'L', false);

// Define the path where the PDF will be saved
$uploadDir = '../uploads/ncar/';
$fileName = 'NCAR-Filled-' . preg_replace('/[^a-zA-Z0-9]/', '-', $office) . "-" . $campus  . '.pdf';
$filepath = $uploadDir . $fileName;

// Check if the directory exists, if not create it
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0777, true); // Create directory if it doesn't exist
}

// Output the file and save it to the specified path
$pdf->Output('F', $filepath);

if (file_exists($filepath)) {
    // Check if the file is already in the database
    $checkStmt = $conn->prepare("SELECT id FROM tbl_ncar_reports WHERE file_path = ?");
    $checkStmt->bind_param("s", $filepath);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();


    if ($checkResult->num_rows == 0) {
        $updateStmt = $conn->prepare("UPDATE tbl_ncar_reports SET file_name = ?, file_path = ? WHERE campus = ? AND office = ?");
        $updateStmt->bind_param("ssss", $fileName, $filepath, $campus, $office);
        $updateStmt->execute();
    }

    echo json_encode([
        'success' => true,
        'file_url' => $filepath
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => "File not found: $filepath"
    ]);
}
