import 'package:flutter/material.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/view/category_view.dart';

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
            color: pPrimaryColor,
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
            leading: const Icon(Icons.space_dashboard),
            iconColor: Colors.amber,
            title: const Text('Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryView()),
              );
            },
          ),
               ListTile(
            leading: const Icon(Icons.menu_book),
            iconColor: Colors.blueAccent,
            title: const Text('Menues'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const MenuView()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            iconColor: Colors.deepPurple,
            title: const Text('Analytics'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const MenuView()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            iconColor: Colors.red,
            title: const Text('Delete Finished Items'),
            onTap: () {
              pantryController.deleteCompleted();
              Scaffold.of(context).closeEndDrawer();
            },
          ),
          const Spacer(),
          ListTile(
            onTap: () {
             //go tp settings view
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
