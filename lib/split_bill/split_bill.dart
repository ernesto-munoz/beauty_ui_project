import 'package:beauty_ui_project/split_bill/custom_radio.dart';
import 'package:beauty_ui_project/split_bill/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new SplitBill());
  });
}

class SplitBill extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Split Bill',
      debugShowCheckedModeBanner: true,
      theme: new ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color(0xFF00C24D),
        scaffoldBackgroundColor: Color(0xFFE4E8F2),
      ),
      home: new MyHomePage(title: 'Split Bill'),
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
  // Business data
  double billAmount;
  double tipPercentageSelected;
  int maxNumPersons;
  int numPersons;

  // User Interface Data
  bool insertingDecimals;

  @override
  void initState() {
    super.initState();
    billAmount = 0.0;
    maxNumPersons = 12;
    tipPercentageSelected = 0.1;
    numPersons = (maxNumPersons * 0.5).toInt();
    insertingDecimals = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
        backgroundColor: Color(0xFF00C24D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildTotalAmountBox(Color(0xFF0E1823)),
            buildNumberPersonsSlider(),
            buildListTipsRadios(),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildKeyboardNumberButton(1),
                buildKeyboardNumberButton(2),
                buildKeyboardNumberButton(3),
              ],
            )),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildKeyboardNumberButton(4),
                buildKeyboardNumberButton(5),
                buildKeyboardNumberButton(6),
              ],
            )),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildKeyboardNumberButton(7),
                buildKeyboardNumberButton(8),
                buildKeyboardNumberButton(9),
              ],
            )),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      '.',
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        insertingDecimals = !insertingDecimals;
                      });
                    },
                  ),
                  buildKeyboardNumberButton(0),
                  FlatButton(
                    child: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      setState(() {
                        if (billAmount > 0.0) {
                          String asString = billAmount.toString();
                          print(insertingDecimals);
                          print(asString);
                          print(asString.substring(asString.length - 2, asString.length));
                          if (insertingDecimals == true &&
                              asString.substring(asString.length - 2, asString.length) == '.0') {
                            insertingDecimals = false;
                          } else {
                            if (insertingDecimals == true) {
                              billAmount =
                                  double.parse(billAmount.toString().substring(0, billAmount.toString().length - 1));
                            } else {
                              if (billAmount.toInt().toString().length == 1) {
                                billAmount = 0.0;
                              } else {
                                billAmount = double.parse(billAmount
                                    .toInt()
                                    .toString()
                                    .substring(0, billAmount.toInt().toString().length - 1));
                              }
                            }
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            buildSplitBillButton(),
          ],
        ),
      ),
    );
  }

  Widget buildSplitBillButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text(
                'SPLIT BILL',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                print('Tip Selected: $tipPercentageSelected');
              },
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  Widget buildKeyboardNumberButton(int number) {
    return FlatButton(
      child: Text(
        number.toString(),
        style: TextStyle(fontSize: 22.0),
      ),
      onPressed: () {
        setState(() {
          if (billAmount <= 0.0)
            billAmount = number * 1.0;
          else if (insertingDecimals == false) {
            if (billAmount.toInt().toString().length <= 3)
              billAmount = double.parse(billAmount.toInt().toString() + number.toString());
          } else {
            String decimals = billAmount.toString();
            if (decimals[decimals.length - 1] == '0') {
              billAmount = double.parse(decimals.substring(0, decimals.length - 1) + number.toString());
            } else {
              billAmount = double.parse(decimals + number.toString());
            }
          }
        });
        billAmount = double.parse(billAmount.toStringAsFixed(3));
      },
    );
  }

  Widget buildListTipsRadios() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
                child: new CustomRadioItem(
                  text: '0%',
                  isSelected: tipPercentageSelected == 0.0,
                ),
                onTap: () {
                  setTipPercentageSelected(0.0);
                }),
            InkWell(
              child: CustomRadioItem(
                text: '10%',
                isSelected: tipPercentageSelected == 0.1,
              ),
              onTap: () {
                setTipPercentageSelected(0.1);
              },
            ),
            InkWell(
              child: CustomRadioItem(
                text: '20%',
                isSelected: tipPercentageSelected == 0.2,
              ),
              onTap: () {
                setState(() {
                  setTipPercentageSelected(0.2);
                });
              },
            ),
            InkWell(
              child: CustomRadioItem(
                text: '30%',
                isSelected: tipPercentageSelected == 0.3,
              ),
              onTap: () {
                setTipPercentageSelected(0.3);
              },
            ),
          ],
        ),
      ),
    );
  }

  void setTipPercentageSelected(double value) {
    setState(() {
      tipPercentageSelected = value;
    });
  }

  Widget buildNumberPersonsSlider() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: 50.0,
        child: CustomSlider(
          defaultSliderPercent: 0.5,
          leftColor: Theme.of(context).primaryColor,
          rightColor: Colors.white,
          maxNumPersons: maxNumPersons,
          onValueChanged: (value) {
            setState(() {
              numPersons = (value * maxNumPersons).toInt();
            });
          },
        ),
      ),
    );
  }

  Widget buildTotalAmountBox(Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Theme.of(context).primaryColor, boxShadow: [
          new BoxShadow(
            color: Colors.green,
            blurRadius: 15.0,
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('TOTAL', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  Text(insertingDecimals == true ? '\$$billAmount' : '\$${billAmount.toInt()}',
                      style: TextStyle(
                          fontSize: 42.0, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('BILL',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('FRIENDS',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('TIPS(' + (tipPercentageSelected * 100).toInt().toString() + '%)',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(insertingDecimals == true ? '\$$billAmount' : '\$${billAmount.toInt()}',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(numPersons.toString(),
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('\$${(billAmount * tipPercentageSelected).toStringAsPrecision(3)}',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
