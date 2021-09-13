import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Progress Indicator';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: DeterminateIndicator(),
  );
}

class DeterminateIndicator extends StatefulWidget {


  @override
  _DeterminateIndicatorState createState() => _DeterminateIndicatorState();
}

class _DeterminateIndicatorState extends State<DeterminateIndicator> {

  File? imageFile;
  double downloadProgress = 0;


  Future downloadImage() async {
    final url =
        'https://images.unsplash.com/photo-1593134257782-e89567b7718a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80';

    final request = Request('GET', Uri.parse(url));
    final response = await Client().send(request);
    final contentLength = response.contentLength;
    final fileDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${fileDirectory.path}/image.jfif';

    imageFile = File(filePath);
    final bytes = <int>[];
    response.stream.listen(
          (streamedBytes) {
        bytes.addAll(streamedBytes);

        setState(() {
          downloadProgress = bytes.length / contentLength!;
        });
      },
      onDone: () async {
        setState(() {
          downloadProgress = 1;
        });
      },
      cancelOnError: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Determinate progress indicator'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            downloadProgress == 1 ? Container(
              width: 250,
                height: 250,
                child: Image.file(imageFile!)
            ) : Text('Download in progress'),
            SizedBox(height: 30),

            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: downloadProgress,
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                    strokeWidth: 10,
                    backgroundColor: Colors.white,
                  ),
                  Center(
                      child: downloadProgress == 1
                          ?
                      Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      )
                          :
                      Text(
                        '${(downloadProgress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      )
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Container(
              width: 200,
              height: 40,
              child: RaisedButton(
                onPressed: downloadImage,
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Row(
                    children: <Widget>[
                      Text(
                        'Download image',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.download,
                        color: Colors.white,
                      )
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



}