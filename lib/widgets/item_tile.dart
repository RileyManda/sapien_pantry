// import 'package:flutter/material.dart';
// import 'package:sapienpantry/model/item.dart';
//
// class ItemTile extends StatelessWidget {
//   final Item item;
//
//   const ItemTile({Key? key, required this.item}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.text,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (item.category != null)
//                     Text(
//                       'Quantity: ${item.category}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   if (item.category != null)
//                     Text(
//                       'Expiry date: ${item.category}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                 ],
//               ),
//             ),
//             if (item.quantity != null)
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: SizedBox(
//                   height: 50,
//                   width: 50,
//                   child:   Text(
//                     'Expiry date: ${item.quantity}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
