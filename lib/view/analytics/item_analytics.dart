import 'package:flutter/material.dart';
import '../../model/pantry.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/constants.dart';

class ItemAnalytics extends StatelessWidget {
  final List<Pantry> popularList;
  ItemAnalytics({Key? key, required this.popularList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalItems = popularList.length;
    int doneItems = popularList.where((pantry) => pantry.isDone).length;
    int notDoneItems = popularList.where((pantry) => !pantry.isDone).length;
    double doneProgress = doneItems > 0 ? doneItems / totalItems : 0.0;
    double notDoneProgress = notDoneItems > 0 ? notDoneItems / totalItems : 0.0;

    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: doneProgress * 100,
                    title: '${(doneProgress * 100).toStringAsFixed(1)}%',
                    color: shoppingColor,
                    titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    value: notDoneProgress * 100,
                    title: '${(notDoneProgress * 100).toStringAsFixed(1)}%',
                    color: pPrimaryColor,
                    titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
                borderData: FlBorderData(show: true),
                centerSpaceRadius: 40,
                sectionsSpace: 0,
                startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                      // Handle pie chart touch events here
                    },
                  ),

              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                color: shoppingColor,
              ),
              SizedBox(width: 5),
              Text('Shopping'),
              SizedBox(width: 20),
              Container(
                width: 20,
                height: 20,
                color: pPrimaryColor,
              ),
              SizedBox(width: 5),
              Text('Pantry'),
            ],
          ),
        ],
      ),
    );
  }
}
