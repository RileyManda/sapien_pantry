import 'package:flutter/material.dart';
import 'package:sapienpantry/model/pantry.dart';

class PantryInfoWidget extends StatefulWidget {
  final Pantry pantry;

  const PantryInfoWidget({Key? key, required this.pantry}) : super(key: key);

  @override
  _PantryInfoWidgetState createState() => _PantryInfoWidgetState();
}

class _PantryInfoWidgetState extends State<PantryInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pantry.text),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category: ${widget.pantry.category}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Quantity: ${widget.pantry.text}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Notes: ${widget.pantry.date}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
