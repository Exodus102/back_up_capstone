<?php

function addContentToPage4($pdf, $quarter, $year, $urstext, $conn, $name, $campus)
{
    $quarterText = [
        '1st Quarter CSS Report' => 'January - March',
        '2nd Quarter CSS Report' => 'April - June',
        '3rd Quarter CSS Report' => 'July - September',
        '4th Quarter CSS Report' => 'October - December'
    ];

    $quarterLabel = $quarterText[$quarter] ?? "January - March";
    $urstext = str_replace("URS", "", $urstext);
    $urstext = trim($urstext) . " CAMPUS";
    $text = "$quarterLabel $year";
    $titleText = "Customer Satisfaction Survey Results";

    $pageWidth = $pdf->GetPageWidth();

    $pdf->SetFont('Arial', 'B', 11);
    $textWidth = $pdf->GetStringWidth($text);
    $textX = ($pageWidth - $textWidth) / 2;
    $pdf->SetXY($textX, 35);
    $pdf->Cell($textWidth, 10, $text, 0, 1, 'C');

    $pdf->SetFont('Arial', 'B', 12);
    $urstextWidth = $pdf->GetStringWidth($urstext);
    $urstextX = ($pageWidth - $urstextWidth) / 2;
    $pdf->SetXY($urstextX, 40);
    $pdf->Cell($urstextWidth, 10, $urstext, 0, 1, 'C');

    $pdf->SetFont('Arial', 'B', 12);
    $pdf->SetXY(30, 50);
    $pdf->Cell(0, 10, $titleText, 0, 1, 'L');

    // table start
    $pdf->AddFont('ArialNarrow', '', 'ARIALN.php');
    $pdf->SetFont('ArialNarrow', '', 10);
    $quarterNumber = explode(' ', $quarter)[0];

    $leftColWidth = 90;
    $smallColWidth = 10;
    $headerRowHeight = 5;
    $rowHeight = 4;
    $leftMargin = 30;

    $pdf->SetLineWidth(0.2);
    $pdf->SetXY($leftMargin, 58);

    $pdf->Cell($leftColWidth, $headerRowHeight * 2, 'DEPARTMENT', 1, 0, 'C');
    $pdf->Cell(60, $headerRowHeight, "$quarterNumber QUARTER", 1, 1, 'C');


    $pdf->SetX($leftMargin + $leftColWidth);
    $headers = ['QoS', 'VI', 'SU', 'VI', 'AVE', 'VI'];
    foreach ($headers as $header) {
        $pdf->Cell($smallColWidth, $headerRowHeight, $header, 1, 0, 'C');
    }
    $pdf->Ln();

    $query = "SELECT division FROM tbl_division";
    $result = mysqli_query($conn, $query);
    function getVisualInterpretation($score)
    {

        if ($score >= 4.50) {
            return 'E';  // Excellent
        } elseif ($score >= 3.50) {
            return 'VS'; // Very Satisfactory
        } elseif ($score >= 2.50) {
            return 'S';  // Satisfactory
        } elseif ($score >= 1.50) {
            return 'US'; // Unsatisfactory
        } else {
            return 'P//NI'; // Poor / No Interpretation
        }
    }

    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_assoc($result)) {
            $pdf->SetX($leftMargin);
            $pdf->SetFont('ArialNarrow', '', 10);
            $divisionName = strtoupper($row['division']);


            $startY = $pdf->GetY();


            $pdf->MultiCell($leftColWidth, $rowHeight, $divisionName, 1, 'L');


            $endY = $pdf->GetY();
            $divisionHeight = $endY - $startY;


            $pdf->SetXY($leftMargin + $leftColWidth, $startY);


            for ($i = 0; $i < 6; $i++) {
                $pdf->Cell($smallColWidth, $divisionHeight, " ", 1, 0, 'C');
            }

            $pdf->Ln();

            $officeQuery = "SELECT office FROM tbl_office 
            WHERE division = '" . mysqli_real_escape_string($conn, $row['division']) . "'
            AND campus = '" . mysqli_real_escape_string($conn, $campus) . "'";
            $officeResult = mysqli_query($conn, $officeQuery);

            if (mysqli_num_rows($officeResult) > 0) {
                while ($officeRow = mysqli_fetch_assoc($officeResult)) {
                    $pdf->SetX($leftMargin);
                    $pdf->SetFont('Arial', '', 10);

                    $indentBoxWidth = 5;
                    $officeBoxWidth = $leftColWidth - $indentBoxWidth;

                    $startY = $pdf->GetY();

                    $pdf->Cell($indentBoxWidth, 0, '', 1, 0, 'C');
                    $pdf->SetX($leftMargin + $indentBoxWidth);

                    $officeText = $officeRow['office'];
                    $startX = $pdf->GetX();

                    $tempHeight = $pdf->GetY();
                    $pdf->MultiCell($officeBoxWidth, $rowHeight, $officeText, 1, 'L');
                    $endY = $pdf->GetY();
                    $actualRowHeight = $endY - $tempHeight;

                    $pdf->SetXY($leftMargin, $startY);
                    $pdf->Cell($indentBoxWidth, $actualRowHeight, '', 1, 0, 'C');

                    // === QUERY TO GET QoS MEAN ===
                    $officeName = mysqli_real_escape_string($conn, $officeRow['office']);
                    $campusName = mysqli_real_escape_string($conn, $campus);

                    $startMonth = 1;
                    $endMonth = 3;

                    if ($quarter == '1st Quarter CSS Report') {
                        $startMonth = 1;
                        $endMonth = 3;
                    } elseif ($quarter == '2nd Quarter CSS Report') {
                        $startMonth = 4;
                        $endMonth = 6;
                    } elseif ($quarter == '3rd Quarter CSS Report') {
                        $startMonth = 7;
                        $endMonth = 9;
                    } elseif ($quarter == '4th Quarter CSS Report') {
                        $startMonth = 10;
                        $endMonth = 12;
                    }

                    $responseQuery = "
                        SELECT response
                        FROM tbl_responses
                        WHERE response_id IN (
                            SELECT response_id
                            FROM tbl_responses
                            WHERE response IN ('$officeName', '$campusName')
                            GROUP BY response_id
                            HAVING COUNT(DISTINCT response) = 2
                        )
                        AND header = 1
                        AND question_rendering = 'QoS'
                        AND YEAR(timestamp) = $year
                        AND MONTH(timestamp) BETWEEN $startMonth AND $endMonth;
                    ";

                    $responseResult = mysqli_query($conn, $responseQuery);

                    $total = 0;
                    $count = 0;

                    while ($responseRow = mysqli_fetch_assoc($responseResult)) {
                        $value = floatval($responseRow['response']);
                        $total += $value;
                        $count++;
                    }

                    $mean = $count > 0 ? round($total / $count, 2) : '-';

                    // === Calculate Visual Interpretation for QoS ===
                    $vi = $mean !== '-' ? getVisualInterpretation($mean) : '';

                    // === QUERY TO GET SU MEAN ===
                    $responseQuerySU = "
                        SELECT response
                        FROM tbl_responses
                        WHERE response_id IN (
                            SELECT response_id
                            FROM tbl_responses
                            WHERE response IN ('$officeName', '$campusName')
                            GROUP BY response_id
                            HAVING COUNT(DISTINCT response) = 2
                        )
                        AND header = 1
                        AND question_rendering = 'SU'
                        AND YEAR(timestamp) = $year
                        AND MONTH(timestamp) BETWEEN $startMonth AND $endMonth;
                    ";

                    $responseResultSU = mysqli_query($conn, $responseQuerySU);

                    $totalSU = 0;
                    $countSU = 0;

                    while ($responseRowSU = mysqli_fetch_assoc($responseResultSU)) {
                        $valueSU = floatval($responseRowSU['response']);
                        $totalSU += $valueSU;
                        $countSU++;
                    }

                    $meanSU = $countSU > 0 ? round($totalSU / $countSU, 2) : '-';

                    // === Calculate Visual Interpretation for SU ===
                    $viSU = $meanSU !== '-' ? getVisualInterpretation($meanSU) : '';

                    // === CALCULATE AVERAGE OF QoS AND SU ===
                    $average = '-';
                    $viAverage = '';

                    if ($mean !== '-' && $meanSU !== '-') {
                        $average = round(($mean + $meanSU) / 2, 2);
                        $viAverage = getVisualInterpretation($average);
                    }

                    // === DRAW QoS Mean, VI, SU Mean, VI, and Average ===
                    $pdf->SetXY($leftMargin + $leftColWidth, $startY);

                    // Display QoS Mean
                    $pdf->Cell($smallColWidth, $actualRowHeight, $mean, 1, 0, 'C');

                    // Display Visual Interpretation for QoS
                    $pdf->Cell($smallColWidth, $actualRowHeight, $vi, 1, 0, 'C');

                    // Display SU Mean
                    $pdf->Cell($smallColWidth, $actualRowHeight, $meanSU, 1, 0, 'C');

                    // Display Visual Interpretation for SU
                    $pdf->Cell($smallColWidth, $actualRowHeight, $viSU, 1, 0, 'C');

                    // Display Average Mean
                    $pdf->Cell($smallColWidth, $actualRowHeight, $average, 1, 0, 'C');

                    // Display Visual Interpretation for Average
                    $pdf->Cell($smallColWidth, $actualRowHeight, $viAverage, 1, 0, 'C');


                    $pdf->Ln();
                }
            }
        }
    } else {
        $pdf->SetX($leftMargin);
        $pdf->SetFont('ArialNarrow', 'B', 8);
        $pdf->Cell($leftColWidth + 60, $rowHeight, "No departments available", 1, 1, 'C');
    }

    $pdf->SetFont('Arial', '', 10);
    $pdf->SetXY($leftMargin, $pdf->GetY() + 10);
    $pdf->Cell(0, 10, 'Prepared by:', 0, 1, 'L');

    $pdf->SetFont('Arial', 'B', 10);
    $pdf->SetXY($leftMargin, $pdf->GetY() + 5);
    $pdf->Cell(0, 10, strtoupper($name), 0, 1, 'L');

    $pdf->SetFont('Arial', '', 10);
    $pdf->SetXY($leftMargin, $pdf->GetY() - 5);
    $pdf->Cell(0, 10, "Coordinator, CSS " . ucwords(strtolower($urstext)), 0, 1, 'L');
}
