import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/utils/pantry_utils.dart';
// import 'package:share_plus/share_plus.dart';
import '../services/pantry_service.dart';
import '../utils/constants.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}
class _SettingsViewState extends State<SettingsView> {
  bool _darkModeEnabled = false;
  final _pantryService = PantryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            ),
            title: Text('User Profile'),
            subtitle: Text('Update your profile information'),
            onTap: () {
              // Navigate to user profile edit screen
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.color_lens),
          //   title: Text('Theme'),
          //   subtitle: Text('Change app theme'),
          //   trailing: Switch(
          //     value: _darkModeEnabled,
          //     onChanged: (value) {
          //       setState(() {
          //         _darkModeEnabled = value;
          //         // Update app theme
          //       });
          //     },
          //   ),
          // ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
            subtitle: Text('Delete your account and all data'),
            onTap: () async {
              // Show password confirmation dialog
              bool passwordConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  String password = '';
                  return AlertDialog(
                    title: const Text('Confirm Password to Delete Account'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Confirm'),
                        onPressed: () async {
                          try {
                            // Confirm the user's password
                            final user = FirebaseAuth.instance.currentUser!;
                            final credential = EmailAuthProvider.credential(email: user.email!, password: password);
                            await user.reauthenticateWithCredential(credential);
                            Navigator.of(context).pop(true);
                          } catch (e) {
                            // Show an error message if the password is incorrect
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect password')));
                          }
                        },
                      ),
                    ],
                  );
                },
              );

              if (passwordConfirmed) {
                // Show delete confirmation dialog
                bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete your account and all data?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
                if (confirm) {
                  // Delete user data from Firestore
                  await _pantryService.deleteUserData();
                  // Navigate to the login screen
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },

          ),
          // ListTile(
          //   leading: Icon(Icons.share),
          //   title: Text('Share App'),
          //   subtitle: Text('Share the app with friends'),
          //   onTap: () {
          //     String appLink = 'https://play.google.com/apps/testing/com.cixhub.sapienpantry';
          //     if (appLink != null) {
          //       Share.share('Check out this cool app: $appLink');
          //     }
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            subtitle: Text('Sign out of your account'),
            onTap: () {
              // Sign out user and navigate to login screen
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
          ),
        ],
      ),
    );
  }
}
