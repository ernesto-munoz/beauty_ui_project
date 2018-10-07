import 'dart:math';

import 'package:flutter/material.dart';

class SecureSeedCheck extends StatefulWidget {
  final String title;
  final List<String> secureSeedWords;

  const SecureSeedCheck({Key key, this.title, this.secureSeedWords}) : super(key: key);

  @override
  _SecureSeedCheckState createState() => _SecureSeedCheckState();
}

class _SecureSeedCheckState extends State<SecureSeedCheck> {
  int selectedNumber;
  List<int> seedNumbers;
  List<int> alreadyCorrectNumbers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seedNumbers = new List<int>();
    alreadyCorrectNumbers = new List<int>();
    selectedNumber = -1;

    int count = 0;
    while (count < 3) {
      int num = Random.secure().nextInt(widget.secureSeedWords.length) + 1;
      if (!seedNumbers.contains(num)) {
        seedNumbers.add(num);
        count++;
      }
    }
    print(seedNumbers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color(0xFF4C7CF3),
        ),
        floatingActionButton: new Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              for (int i = 0; i < seedNumbers.length; ++i) {
                if (!alreadyCorrectNumbers.contains(seedNumbers[i])) {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("Secure Seed Incorrect!"),
                  ));
                  return;
                }
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Secure Seed Passed!"),
                ));
              }
            },
            elevation: 10.0,
            backgroundColor: Color(0xFF4C7CF3),
            child: Icon(Icons.arrow_forward),
          );
        }),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Enter the higlighted numbers',
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
//              Flexible(
//                fit: FlexFit.tight,
//                child: GridView.count(
//                    childAspectRatio: 0.8,
//                    padding: EdgeInsets.all(15.0),
//                    crossAxisCount: 6,
//                    children: List.generate(widget.secureSeedWords.length, (index) {
//                      return buildNumberCheck(index + 1);
//                    })),
//              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildNumberCheck(1),
                  buildNumberCheck(2),
                  buildNumberCheck(3),
                  buildNumberCheck(4),
                  buildNumberCheck(5),
                  buildNumberCheck(6),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildNumberCheck(7),
                  buildNumberCheck(8),
                  buildNumberCheck(9),
                  buildNumberCheck(10),
                  buildNumberCheck(11),
                  buildNumberCheck(12),
                ],
              ),
              Container(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 2.0, left: 42.0, right: 32.0),
                    child: Text(
                      selectedNumber == -1 ? 'Select a number' : selectedNumber.toString().padLeft(2, '0'),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 32.0, right: 32.0),
                child: TextField(
                  enabled: selectedNumber != -1 && !alreadyCorrectNumbers.contains(selectedNumber),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: selectedNumber == -1 ? 'Select a number' : "Enter seed for number " + selectedNumber.toString(),
                  ),
                  onChanged: (value) {
                    if (value.toLowerCase().compareTo(widget.secureSeedWords[selectedNumber - 1]) == 0) {
                      alreadyCorrectNumbers.add(selectedNumber);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildNumberCheck(int number) {
    bool isSelected = selectedNumber == number ? true : false;
    bool isSeedNumber = seedNumbers.contains(number) ? true : false;

    Widget getIcon() {
      if (isSeedNumber == true) {
        if (alreadyCorrectNumbers.contains(number)) {
          return Icon(Icons.check);
        } else {
          return Icon(Icons.close);
        }
      }
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 30.0,
        height: 50.0,
        padding: EdgeInsets.all(0.0),
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: isSeedNumber
              ? () {
                  setState(() {
                    selectedNumber = number;
                  });
                  print('SELECTED');
                }
              : null,
          disabledColor: Color(0xFFEFEFEF),
          color: isSelected ? Color(0xFF4C7CF3) : Color(0xFFEEF2FE),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(number.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: getIcon(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
