import 'package:flutter/material.dart';
import 'package:pepe_zip_one/my_divider.dart';
import 'package:pepe_zip_one/screens/googledrive_route.dart';
import 'package:pepe_zip_one/screens/onedrive_route.dart';
import 'package:pepe_zip_one/screens/dropbox_route.dart';


class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          MyDivider('Cloud drives'),
          ListTile(
            leading:Image.asset('assets/images/Dropbox-Icon.png'),
            title: Text('Dropbox'),
            trailing:Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => DropBoxRoute()));

            },
          ),
          ListTile(
            leading:Image.asset('assets/images/Microsoft-OneDrive-icon.png'),
            title: Text('OneDrive'),
            trailing:Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => OneDriveRoute()));

            },
          ),
          ListTile(
            leading:Image.asset('assets/images/Google-Drive-icon.png'),
            title: Text('Google Drive'),
            trailing:Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => GoogleDriveRoute()));
            },
          ),
          ListTile(
            title: Text('ZipShare'),
            trailing:Icon(Icons.arrow_forward),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
          MyDivider('Access from the cloud'),
          ListTile(
            title: Text('Settings'),

            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.settings), // icon-1
                Icon(Icons.message), // icon-2
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
          MyDivider('About'),
          ListTile(
            title: Text('feedback'),

            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.settings), // icon-1
                Icon(Icons.message), // icon-2
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
          ListTile(
            title: Text('user guide'),

            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.settings), // icon-1
                Icon(Icons.message), // icon-2
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
          ListTile(
            title: Text('Privacy Policy'),

            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.settings), // icon-1
                Icon(Icons.message), // icon-2
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
          ListTile(
            title: Text('App version'),

            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.settings), // icon-1
                Icon(Icons.message), // icon-2
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer

            },
          ),
        ],
      ),
      ),
    );
  }
}