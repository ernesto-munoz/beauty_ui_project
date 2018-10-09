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
  int numFriends;
  double tipsPercentage;

  // User Interface Data

  @override
  void initState() {
    super.initState();
    billAmount = 0.0;
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Icon(Icons.add),
                ),
                buildKeyboardNumberButton(0),
                FlatButton(
                  child: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if(billAmount > 0.0)
                        billAmount = double.parse(billAmount.toString().substring(0, billAmount.toString().length - 1));
                    });
                  },
                ),
              ],
            )),
            buildSplitBillButton(),
          ],
        ),
      ),
    );
  }

  Padding buildSplitBillButton() {
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
              onPressed: () {},
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }

  Widget buildKeyboardNumberButton(int number) {
    return FlatButton(
      child: Text(number.toString()),
      onPressed: () {
        setState(() {
          if(billAmount <= 0.0)
            billAmount = number * 1.0;
          else
            billAmount = double.parse(billAmount.toString() + number.toString());
        });
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
            Radio(
              value: 1,
              groupValue: 1,
              onChanged: (e) {},
            ),
            Radio(
              value: 2,
              groupValue: 2,
              onChanged: (e) {},
            ),
            Radio(
              value: 3,
              groupValue: 1,
              onChanged: (e) {},
            ),
            Radio(
              value: 4,
              groupValue: 1,
              onChanged: (e) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumberPersonsSlider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50.0,
        child: CustomSlider(
          leftColor: Theme.of(context).primaryColor,
          rightColor: Colors.white,
          maxNumPersons: 12,
        ),
      ),
//      child: Container(
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Slider(
//              value: 4.0,
//              max: 10.0,
//              min: 1.0,
//            ),
//            Text('4')
//          ],
//        ),
//      ),
    );
  }

  Widget buildTotalAmountBox(Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('TOTAL', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                Text('\$$billAmount',
                    style: TextStyle(
                        fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('BILL',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('FRIENDS',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text('TIPS(10%)',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white)),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('\$80.00',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('4',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text('\$8.00',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white)),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
