import 'package:beauty_ui_project/secure_seed/secure_seed_check.dart';
import 'package:beauty_ui_project/secure_seed/seed_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() => runApp(new SecureSeed());

class SecureSeed extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Secure Seed',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Secure Seed'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _switchSavedValue = false;
  int numWords = 12;
  List<String> words;

  @override
  void initState() {
    super.initState();
    retrieveSeedWords();
  }

  void retrieveSeedWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);
//    prefs.remove('secure_seed_words');
    setState(() {
      List<String> retrievedWords = prefs.getStringList('secure_seed_words');
      if (retrievedWords == null) {
        words = SeedWords.getSeedWordsList(numWords);
        prefs.setStringList('secure_seed_words', words);
      } else {
        words = retrievedWords;
      }
      print(words);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF4C7CF3),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (words == null || _switchSavedValue == false) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecureSeedCheck(title: widget.title, secureSeedWords: words)),
          );
        },
        elevation: 10.0,
        backgroundColor: words == null || _switchSavedValue == false ? Colors.grey : Color(0xFF4C7CF3),
        child: Icon(Icons.arrow_forward),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: Text('This is your secure seed',
                  style: TextStyle(color: Colors.black87, fontSize: 26.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Keep your phrase super safe, dont share anyone',
                  style: TextStyle(color: Colors.black54, fontSize: 16.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center),
            ),
            words == null
                ? Container(child: Text('Creating your secure seed...'))
                : Flexible(
                    fit: FlexFit.loose,
                    child: GridView.count(
                        childAspectRatio: 1.85,
                        padding: EdgeInsets.all(15.0),
                        crossAxisCount: 3,
                        children: List.generate(numWords, (index) {
                          return buildSeedButton(index + 1, words[index]);
                        })),
                  ),
            words == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0, left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Switch(
                          value: _switchSavedValue,
                          activeColor: Color(0xFF4C7CF3),
                          onChanged: (bool value) {
                            setState(() {
                              _switchSavedValue = value;
                            });
                          },
                        ),
                        Text('I\'ve written down in my diary'),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildSeedButton(int number, String word) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
          bottom: 3.0,
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF4F5F7)),
          ),
        ),
        Container(
          width: 110.0,
          height: 25.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: Color(0xFFF4F5F7)),
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 5.0, bottom: 5.0),
            child: Text(word, style: TextStyle(color: Color(0xFF282D2F), fontSize: 14.0)),
          ),
        ),
        Positioned(
            bottom: 30.0, child: Text(number.toString(), style: TextStyle(color: Color(0xFF282D2F), fontSize: 14.0))),
      ],
    );
  }
}
