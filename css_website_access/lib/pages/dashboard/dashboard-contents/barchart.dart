import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Barchart extends StatefulWidget {
  final List<BarChartGroupData> barData;
  final List<String> offices;
  const Barchart({
    super.key,
    required this.barData,
    required this.offices,
  });

  @override
  State<Barchart> createState() => _BarchartState();
}

class _BarchartState extends State<Barchart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toString(),
                TextStyle(
                  color: Colors.white, // 👈 text color for visibility
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        alignment: BarChartAlignment.spaceAround,
        maxY: 25,
        barGroups: widget.barData,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 5,
              getTitlesWidget: (value, meta) {
                if (value == 25) {
                  return SizedBox.shrink();
                }
                return value % 5 == 0
                    ? Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                          color: Color(0xFF064089),
                          fontSize: 12,
                        ),
                      )
                    : Container();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int officeIndex = value.toInt();
                if (officeIndex < widget.offices.length) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.offices[
                          officeIndex], // Get office name based on index
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return Container(); // Return empty container if index is out of bounds
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) => value % 5 == 0 || value == 0,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Color(0xFF949699),
            strokeWidth: 2,
          ),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
