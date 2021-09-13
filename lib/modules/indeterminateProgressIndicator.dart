import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Progress Indicator';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: IndeterminateIndicator(),
  );
}

class IndeterminateIndicator extends StatefulWidget {


  @override
  _IndeterminateIndicatorState createState() => _IndeterminateIndicatorState();
}

class _IndeterminateIndicatorState extends State<IndeterminateIndicator> {

  String? name;
  String? username;
  String? publicRepos;
  String? publicGists;
  String? followers;
  String? following;
  bool isLoading = false;



  Future<void> fetchData() async{
    setState(() {
      isLoading = true;
    });


    try {
      Response response = await get(
          Uri.parse('https://api.github.com/users/olu-damilare'));
      Map data = jsonDecode(response.body);


      setState(() {
        name = data['name'];
        username = data['login'];
        publicRepos = data['public_repos'].toString();
        publicGists = data['public_gists'].toString();
        followers = data['followers'].toString();
        following = data['following'].toString();
        isLoading = false;
      });



    }catch(e){
      print('caught error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
        title: Text('Indeterminate progress indicator'),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        elevation: 0.0,
    ),
        body: isLoading ?
        Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: SpinKitCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            )
        )
        :
        Padding(
        padding: EdgeInsets.all(60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

          Row(
            children: [
              buildParam('NAME:'),
              SizedBox(width: 15.0),
              name == null ? Text('') : buildData(name!),
            ],
          ),
          SizedBox(height: 20.0),
            Row(
              children: [
                buildParam('USERNAME:'),
                SizedBox(width: 15.0),
                name == null ? Text('') : buildData('@${username}'),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                buildParam('PUBLIC REPOS:'),
                SizedBox(width: 15.0),
                name == null ? Text('') : buildData(publicRepos!),
              ],
            ),

          SizedBox(height: 20.0),
            Row(
              children: [
                buildParam('PUBLIC GISTS:'),
                SizedBox(width: 15.0),
                name == null ? Text('') : buildData(publicGists!),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                buildParam('FOLLOWERS:'),
                SizedBox(width: 15.0),
                name == null ? Text('') : buildData(followers!),
              ],
            ),

            SizedBox(height: 20.0),
            Row(
              children: [
                buildParam('FOLLOWING:'),
                SizedBox(width: 15.0),
                name == null ? Text('') : buildData(following!),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 30),
              child: RaisedButton(
                color: Colors.amber,
                onPressed: fetchData,
                child: Text(
                    'Fetch data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            )
          ]
          ),
          ),
          );
      }

      Widget buildParam(String param){
        return Text(
          param,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        );
      }

      Widget buildData(String data){
        return Text(
          data,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.amber[400],
          ),
        );
      }
}

