import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pepe_zip_one/screens/first_route.dart';
import 'package:pepe_zip_one/screens/settings_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:pepe_zip_one/screens/ziping_files_route.dart';
import 'package:pepe_zip_one/screens/unziping_files_route.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Pepe Zip';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(appTitle),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage(this.title);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body:Center(child: Column(
        children: <Widget>[
          ListTile(
            leading:Image.asset('assets/images/zip.png'),
            title: Text('Zip stuff'),
            trailing:Icon(Icons.arrow_forward),
            onTap: () {
              //Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZipiingRoute()),);
            },
          ),
          ListTile(
            leading:Image.asset('assets/images/uncompress.png'),
            title: Text('UnZip stuff'),
            trailing:Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UnZipiingRoute()),);
            },
          ),
          Text('pepe zip tool'),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain, // otherwise the logo will be tiny
              child: const FlutterLogo(),
            ),
          ),
        ],
      ),),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/computer-9-250x250.jpg'),
                      fit: BoxFit.cover
                  )
              ),
              child: Text("Pepe Zip"),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstRoute()),
                );
              },
            ),
            Row(children: <Widget>[
                Expanded(
                  child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Divider(
                  color: Colors.blue,
                  height: 50,
                  )),
                ),

                Text("Settings",
                    style: TextStyle(color: Colors.blue)),

                Expanded(
                  child: new Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Divider(
                  color: Colors.blue,
                  height: 50,
                  )),
                ),
              ]
            ),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsRoute()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
void _pickFilesToZip() async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

  if (result != null) {
    List<File> files = result.paths.map((path) => File(path ?? "")).toList();
    final zippedFilePath = zipFile(zipFileSavePath:await _getPathToDownload(),zipFileName: "testZipFiles.zip",fileToZips:files);

    print(zippedFilePath);

  } else {
    // User canceled the picker
  }
}

  Future<String> _getPathToDownload() async {
    return ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  String zipFile({
    required String zipFileSavePath,
    required String zipFileName,
    required List<File> fileToZips,
  }) {
    final ZipFileEncoder encoder = ZipFileEncoder();
    // Manually create a zip at the zipFilePath
    final String zipFilePath = join(zipFileSavePath, zipFileName);
    encoder.create(zipFilePath);
    // Add all the files to the zip file
    for (final File fileToZip in fileToZips) {
      encoder.addFile(fileToZip);
    }
    encoder.close();
    return zipFilePath;
  }
  Future<void> unzipFile({
    required File zipFile,
    required String extractToPath,
  }) async {
    // Read the Zip file from disk.
    final bytes = await zipFile.readAsBytes();
    // Decode the Zip file
    final Archive archive = ZipDecoder().decodeBytes(bytes);
    // Extract the contents of the Zip archive to extractToPath.
    for (final ArchiveFile file in archive) {
      final String filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$extractToPath/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);

      } else {// it should be a directory
        Directory('$extractToPath/$filename').create(recursive: true);
      }
    }
  }
}
