import 'package:flutter/material.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/messages.dart';
import 'package:sapienpantry/view/analytics/analytics_view.dart';
import 'package:sapienpantry/view/menue_view.dart';
import 'package:sapienpantry/view/analytics/pantry_analytics.dart';
import 'package:sapienpantry/view/settings_view.dart';
import '../services/pantry_service.dart';

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
            child: Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
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
          ),
               ListTile(
            leading: const Icon(Icons.set_meal_sharp),
            iconColor: Colors.deepOrangeAccent,
            title: const Text('Recipes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart),
            iconColor: Colors.deepPurple,
            title: const Text('Analytics'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AnalyticsView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            iconColor: Colors.red,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Delete Finished Items'),
                Icon(Icons.check_circle_rounded, color: Colors.grey,),
                SizedBox(width: 8),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      bool deletionInProgress = false;
                      return AlertDialog(
                        title: const Text('Delete Confirmation'),
                        content: deletionInProgress
                            ? const LinearProgressIndicator()
                            : const Text(
                          'Are you sure you want to delete all completed items in your Pantry and clear your shopping list?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: deletionInProgress
                                ? Text('Deletion in Progress')
                                : Text('Delete'),
                            onPressed: () async {
                              if (!deletionInProgress) {
                                setState(() {
                                  deletionInProgress = true;
                                });
                                final PantryService _pantryService = PantryService();
                                await _pantryService.deleteCompleted();
                                deleteCompleted(context);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          const Spacer(),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SettingsView()),
              );
             //go tp settings view
            },
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Sign Out'),
                    content: Text('Are you sure you want to sign out?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Sign Out'),
                        onPressed: () {
                          authController.signOut();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            leading: const Icon(Icons.logout),
            title: const Text('SignOut'),
          ),
        ],
      ),
    );
  }
}
