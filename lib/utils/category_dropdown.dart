// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CategoryDropdown extends StatefulWidget {
//   @override
//   _CategoryDropdownState createState() => _CategoryDropdownState();
// }
//
// class _CategoryDropdownState extends State<CategoryDropdown> {
//   final TextEditingController _categoryController = TextEditingController();
//   String _selectedCategory;
//   List<String> _categories = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//   }
//
//   void _fetchCategories() async {
//     final QuerySnapshot querySnapshot =
//     await FirebaseFirestore.instance.collection('categories').get();
//     final List<String> categories =
//     querySnapshot.docs.map((doc) => doc.data()!['category'] as String).toList();
//     setState(() {
//       _categories = categories;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         DropdownButton<String>(
//           value: _selectedCategory,
//           onChanged: (String value) {
//             setState(() {
//               _selectedCategory = value;
//               _categoryController.text = value;
//             });
//           },
//           items: _categories
//               .map<DropdownMenuItem<String>>(
//                   (String category) => DropdownMenuItem<String>(
//                 value: category,
//                 child: Text(category),
//               ))
//               .toList(),
//         ),
//         Expanded(
//           child: TextField(
//             controller: _categoryController,
//             decoration: InputDecoration(
//               labelText: 'Category',
//             ),
//             onChanged: (String value) {
//               setState(() {
//                 _selectedCategory = value;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
