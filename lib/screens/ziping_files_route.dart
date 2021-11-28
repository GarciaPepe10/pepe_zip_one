import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late List<File> getFiles;
  final myController = TextEditingController();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _littleFont = const TextStyle(fontSize: 7.0);
  Future<bool>? googleAccount;
  Future<bool>? dropboxAccount;

  _ZipiingRouteState(){
    notAsyncThereIsGoogleAccount();
    notAsyncThereIsDropBoxAccount();
  }
  _fillListFiles() {
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
      body: SingleChildScrollView(
      child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 400,
                    height: 250,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: _widgetLoaded?_textFromFile:ListTile(
                      leading:Image.asset('assets/images/file.png'),
                      title: Text('chose the origen'),
                      trailing:Icon(Icons.arrow_forward),
                      onTap: () {
                        _fillListFiles();
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
              leading:Image.asset('assets/images/pngwing.com.png'),
              title: Text('chose the destination'),
              trailing:Icon(Icons.arrow_forward),
              onTap: () {
                _selectFolder();
              },
            ),
            FutureBuilder<bool>(
                future: googleAccount,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false) {
                    return SizedBox.shrink();
                  } else {
                    return ListTile(
                        leading:Image.asset('assets/images/Google-Drive-icon.png'),
                        title: Text('chose the destination'),
                        trailing:Icon(Icons.arrow_forward),
                        onTap: () {
                          _fillListFiles();
                        }
                    );
                  }
                }
            ),
            FutureBuilder<bool>(
                future: dropboxAccount,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == false) {
                    return SizedBox.shrink();
                  } else {
                    return ListTile(
                        leading:Image.asset('assets/images/Dropbox-Icon.png'),
                        title: Text('chose the destination'),
                        trailing:Icon(Icons.arrow_forward),
                        onTap: () {
                          _fillListFiles();
                        }
                    );
                  }
                }
            ),
            TextField(
              controller: myController,
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
                _zipFiles();
                _showToast(context);

              },
            ),
            ]
      )
    ));
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
    getFiles =  await _pickFilesToZip();
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: getFiles.length,
        itemBuilder: (context, i) {
          return _buildRow(getFiles[i]);
        });
  }

  Widget _buildRow(File file) {
    return ListTile(
      title: Text(
        file.path,
        style: _littleFont,
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

  void _zipFiles(){
    final zippedFilePath = zipFile(zipFileSavePath:_directoryPath ?? "",zipFileName: myController.text,fileToZips:getFiles);
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

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('done'),
      ),
    );
  }
  void notAsyncThereIsGoogleAccount(){
    googleAccount = _thereIsGoogleAccount();
  }
  Future<bool> _thereIsGoogleAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('google_user') ?? "";
    if(user != "")
      return true;
    else
      return false;
  }

  void notAsyncThereIsDropBoxAccount(){
    dropboxAccount = _thereIsDropBoxAccount();
  }
  Future<bool> _thereIsDropBoxAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('dropbox_user') ?? "";
    if(user != "")
      return true;
    else
      return false;
  }
}
