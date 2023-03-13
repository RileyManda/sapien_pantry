import 'package:flutter/material.dart';
import 'package:sapienpantry/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            alignment: Alignment.bottomLeft,
            color: pPrimaryColor.shade400,
            // padding: const EdgeInsets.all(16.0),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  '${authController.user!.email}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart_outlined),
            iconColor: Colors.lightGreen,
            title: const Text('Add items to ShoppingList'),
            onTap: () {
              itemController.deleteCompleted();
              Scaffold.of(context).closeEndDrawer();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Delete Finished Items'),
            onTap: () {
              itemController.deleteCompleted();
              Scaffold.of(context).closeEndDrawer();
            },
          ),
          const Spacer(),
          ListTile(
            onTap: () {
              authController.signOut();
            },
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
          ),
          ListTile(
            onTap: () {
              authController.signOut();
            },
            leading: const Icon(Icons.logout),
            title: const Text('SignOut'),
          ),


        ],
      ),
    );
  }
}
