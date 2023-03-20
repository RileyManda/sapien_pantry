
import 'package:flutter/material.dart';


comingSoon() {
  var context;
  ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
    content: Text('Feature coming soon'),
    backgroundColor: Colors.grey,
  ));
}
