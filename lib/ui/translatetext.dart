import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String translatedText = '';
  final TextEditingController _textController = new TextEditingController();
  String url =
      'https://translation.googleapis.com/language/translate/v2?target=gu&key=AIzaSyBt-pjMZD3an-BcyzGgN23Lx6tqTiyaWTI&q=how are you';
  String input = "";
  final translator = GoogleTranslator();

  @override
  void initState() {
    //print(widget.products.);
    //widget.products.forEach((product) => print(product.name));
    super.initState();
    _fetchData(url);
  }

  void _fetchData(String url) async {
    var res = await http.get(url);
    print(res.statusCode);
    print(res.body);
    var decodedJson = jsonDecode(res.body);
    //return HerosHub.fromJson(decodedJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _textController,
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                input = _textController.text;
                translator.translate(input, to: 'gu').then((s) {
                  translatedText = s;
                });
              });
            },
            child: Text('hello'),
          ),
          Text('$translatedText'),
        ],
      ),
    );
  }
}
