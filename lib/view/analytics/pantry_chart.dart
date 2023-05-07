import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';

class PantryChart extends StatelessWidget {
  final List<Pantry> itemList;

  PantryChart({Key? key, required this.itemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalItems = itemList.length;
    int doneItems = itemList.where((pantry) => pantry.isDone).length;
    int notDoneItems = itemList.where((pantry) => !pantry.isDone).length;
    double doneProgress = doneItems > 0 ? doneItems / totalItems : 0.0;
    double notDoneProgress = notDoneItems > 0 ? notDoneItems / totalItems : 0.0;

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: doneItems.toDouble(), // done items
                  color: shoppingColor,
                  width: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: notDoneItems.toDouble(),
                  color: pPrimaryColor, // Use red color for not done items
                  width: 16,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
              showingTooltipIndicators: [0],

            ),
          ],
          gridData: FlGridData(
            show: true,
            checkToShowHorizontalLine: (value) => value % 10 == 0,
            getDrawingHorizontalLine: (value) => FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitle(
              showTitle: true,
              titleText: 'Bottom Title',
              textStyle: const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 20,
              reservedSize: 22,
              interval: 1,
            ),
            leftTitles: AxisTitle(
              showTitle: true,
              titleText: 'Left Title',
              textStyle: const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 32,
              reservedSize: 14,
              interval: 1,
            ),

          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(
                color: Color(0xff37434d),
                width: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }



  AxisTitle({required bool showTitle, required String titleText, required TextStyle textStyle, required int margin, required int reservedSize, required int interval}) {}
}
