import 'package:flutter/material.dart';
import 'package:sapienpantry/view/analytics/pantry_analytics.dart';
import 'package:sapienpantry/view/analytics/item_analytics.dart';
import 'package:sapienpantry/view/analytics/pantry_chart.dart';

import '../../model/pantry.dart';
import '../../services/pantry_service.dart';
class AnalyticsView extends StatefulWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  final _pantryService = PantryService();
  late Stream<List<Pantry>> _streamPantryList;

  @override
  void initState() {
    _streamPantryList = _pantryService.streamPantryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStreamBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder<List<Pantry>>(
      stream: _streamPantryList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pantryList = snapshot.data!;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Card(child: PantryAnalytics(pantryList: pantryList)),
              ),
              Expanded(
                child: Card(child: PantryChart(itemList: pantryList)),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }





}

