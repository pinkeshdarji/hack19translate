import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class Translateone extends StatefulWidget {
  Translateone({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TranslateoneState createState() => _TranslateoneState();
}

class _TranslateoneState extends State<Translateone> {
  String translatedText = '';
  final TextEditingController _textController = new TextEditingController();
  String url = '';
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
      backgroundColor: Colors.redAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('messages').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();

              //return _buildList(context, snapshot.data.documents);

              return Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.blueAccent),
                    child: snapshot.data.documents[0].data['from'] == 1
                        ? Text(
                            '${snapshot.data.documents[0].data['message_text']}')
                        : Text(''),
                  ),
                  TextField(
                    controller: _textController,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        input = _textController.text;

                        translator.translate(input, to: 'en').then((s) {
                          translatedText = s;
                          snapshot.data.documents[0].reference.updateData(
                              {'message_text': '$translatedText', "from": 2});
                        });
                      });
                    },
                    child: Text('send'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class Message {
  final int from;
  final int to;
  final String message_text;
  final DocumentReference reference;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['from'] != null),
        assert(map['to'] != null),
        from = map['from'],
        to = map['to'],
        message_text = map['message_text'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
