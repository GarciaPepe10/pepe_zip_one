import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:english_words/english_words.dart';
import 'dart:io';

class ZipiingRoute extends StatefulWidget {

  @override
  _ZipiingRouteState createState() => _ZipiingRouteState();
}


class _ZipiingRouteState extends State<ZipiingRoute > {

  String? _directoryPath;
  bool _userAborted = false;
  bool _isLoading = false;
  bool _widgetLoaded = false;
  late Widget _textFromFile;

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  _StatefulWidgetDemoState() {
    _buildSuggestions().then((val) => setState(() {
      _textFromFile = val;
      _widgetLoaded = true;
    }));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Zipping Files"),
      ),
      body: Column(
          children: <Widget>[
            ListTile(
              leading:Image.asset('assets/images/zip.png'),
              title: Text('chose the origen'),
              trailing:Icon(Icons.arrow_forward),
              onTap: () {
                _selectFolder();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 250,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: _widgetLoaded?_textFromFile:ListTile(
                      leading:Image.asset('assets/images/zip.png'),
                      title: Text('chose the origen'),
                      trailing:Icon(Icons.arrow_forward),
                      onTap: () {
                        _StatefulWidgetDemoState();
                      },
                    )
                ),
              ),
            ),


            _directoryPath != null ?ListTile(
              title: const Text('Directory path'),
              subtitle: Text(_directoryPath!),
            ):
              ListTile(
              leading:Image.asset('assets/images/zip.png'),
              title: Text('chose the destination'),
              trailing:Icon(Icons.arrow_forward),
              onTap: () {
                _selectFolder();
              },
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'name of the  zip archive',
                  hintText: 'put the name of the zip archive'),
            ),
            ListTile(
              leading:Image.asset('assets/images/zip.png'),
              title: Text('Zip stuff'),
              trailing:Icon(Icons.arrow_forward),
              onTap: () {

              },
            ),
            ]
      )
    );
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _userAborted = false;
    });
  }
  void _logException(String message) {
    print(message);
  }

  Future<Widget> _buildSuggestions() async  {
    List<File> getFiles =  await _pickFilesToZip();
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          
          return _buildRow(getFiles[i]);
        });
  }

  Widget _buildRow(File file) {
    return ListTile(
      title: Text(
        file.path,
        style: _biggerFont,
      ),
    );
  }


  Future<List<File>> _pickFilesToZip() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    List<File> files;
    if (result != null) {
      files = result.paths.map((path) => File(path ?? "")).toList();

    } else {
      files = new List.filled(0,File(""),growable: true);
    }

    return files;
  }
}