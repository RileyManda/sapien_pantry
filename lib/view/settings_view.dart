import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _darkModeEnabled = false;

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
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            subtitle: Text('Change app theme'),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                  // Update app theme
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
            subtitle: Text('Delete your account and all data'),
            onTap: () {
              // Show delete confirmation dialog
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share App'),
            subtitle: Text('Share the app with friends'),
            onTap: () {
              // Share app link using share package
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            subtitle: Text('Sign out of your account'),
            onTap: () {
              // Sign out user and navigate to login screen
            },
          ),
        ],
      ),
    );
  }
}
