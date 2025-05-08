<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header('Access-Control-Allow-Headers: Content-Type');

require '../db_connection.php';
$campus = "Binangonan";
$year = isset($_GET['year']) ? intval($_GET['year']) : date("Y");

function getRatingColumns($type)
{
    global $conn;
    $result = $conn->query("SHOW COLUMNS FROM tbl_response");
    $columns = [];

    while ($row = $result->fetch_assoc()) {
        if ($type === 'rating' && strpos($row['Field'], 'rating_') === 0 && strpos($row['Field'], 'page5_rating_') === false) {
            $columns[] = $row['Field'];
        } elseif ($type === 'page5' && strpos($row['Field'], 'page5_rating_') === 0) {
            $columns[] = $row['Field'];
        }
    }

    return $columns;
}

function getQuarterReport($quarter, $column, $officeUnit, $campus, $year)
{
    global $conn;
    $startMonth = ($quarter - 1) * 3 + 1;
    $endMonth = $startMonth + 2;

    $sql = "SELECT $column FROM tbl_response WHERE YEAR(created_at) = ? AND MONTH(created_at) BETWEEN ? AND ? AND officeUnit = ? AND campus = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("iiiss", $year, $startMonth, $endMonth, $officeUnit, $campus);
    $stmt->execute();
    $result = $stmt->get_result();

    $totalRating = 0;
    $count = 0;

    while ($row = $result->fetch_assoc()) {
        if (!is_null($row[$column])) {
            $totalRating += floatval($row[$column]);
            $count++;
        }
    }

    $stmt->close();

    return ($count > 0) ? number_format($totalRating / $count, 2, '.', '') : '0.00';
}

function getOverallAverage($quarter, $officeUnit, $campus, $type, $year)
{
    $columns = getRatingColumns($type);
    $totalAverage = 0;
    $columnCount = count($columns);
    $validColumns = 0;

    foreach ($columns as $column) {
        $columnAverage = floatval(getQuarterReport($quarter, $column, $officeUnit, $campus, $year));
        if ($columnAverage > 0) {
            $totalAverage += $columnAverage;
            $validColumns++;
        }
    }

    return ($validColumns > 0) ? number_format($totalAverage / $validColumns, 2, '.', '') : '0.00';
}

function getRatingCategory($average)
{
    if ($average >= 4.50) {
        return "E"; // Excellent
    } elseif ($average >= 3.50) {
        return "VS"; // Very Satisfactory
    } elseif ($average >= 2.50) {
        return "S"; // Satisfactory
    } elseif ($average >= 1.50) {
        return "US"; // Needs Improvement
    } else {
        return "P/NI"; // Unsatisfactory
    }
}

$sql = "SELECT DISTINCT officeUnit FROM tbl_response WHERE campus = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $campus);
$stmt->execute();
$result = $stmt->get_result();

$officeReports = [];

while ($row = $result->fetch_assoc()) {
    $officeUnit = $row['officeUnit'];

    $quarters = ["1st_quarter", "2nd_quarter", "3rd_quarter", "4th_quarter"];
    $ratingResults = [];
    $page5Results = [];
    $combinedResults = [];

    foreach ($quarters as $index => $quarter) {
        $qNum = $index + 1;
        $ratingAverage = getOverallAverage($qNum, $officeUnit, $campus, 'rating', $year);
        $page5Average = getOverallAverage($qNum, $officeUnit, $campus, 'page5', $year);

        $ratingResults[$quarter] = [
            "average" => $ratingAverage,
            "category" => getRatingCategory($ratingAverage)
        ];

        $page5Results[$quarter] = [
            "average" => $page5Average,
            "category" => getRatingCategory($page5Average)
        ];

        // Calculate combined average (only if both have valid values)
        if ($ratingAverage > 0 && $page5Average > 0) {
            $combinedAverage = number_format(
                (floatval($ratingAverage) + floatval($page5Average)) / 2,
                2,
                '.',
                ''
            );
        } else {
            $combinedAverage = $ratingAverage > 0 ? $ratingAverage : $page5Average;
        }

        $combinedResults[$quarter] = [
            "average" => $combinedAverage,
            "category" => getRatingCategory($combinedAverage)
        ];
    }

    $officeReports[] = [
        "officeUnit" => $officeUnit,
        "campus" => $campus,
        "rating" => $ratingResults,
        "page5_rating" => $page5Results,
        "combined_averages" => $combinedResults
    ];
}

echo json_encode($officeReports, JSON_PRETTY_PRINT);

$conn->close();
