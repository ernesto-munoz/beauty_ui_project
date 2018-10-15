import 'package:beauty_ui_project/split_bill/custom_radio.dart';
import 'package:beauty_ui_project/split_bill/custom_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitBillDivider extends StatefulWidget {
  final String title;
  final int numPersons;
  final double tipPercentage;
  final double billAmount;

  SplitBillDivider({Key key, this.title, this.numPersons, this.tipPercentage, this.billAmount}) : super(key: key);

  @override
  _SplitBillDividerState createState() => new _SplitBillDividerState();
}

class _SplitBillDividerState extends State<SplitBillDivider> {
  List<double> percentageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.numPersons; ++i) {
      percentageList.add(1.0 / widget.numPersons);
    }
//    percentageList[2] -= 0.1;
//    percentageList[3] += 0.1;
    print('Percantages list: $percentageList');
  }

  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
        backgroundColor: Color(0xFF00C24D),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          buildTotalAmountBox(Color(0xFF0E1823)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 8.0, left: 14.0, right: 14.0),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: getPersonItemList(constraints),
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: getButtonSlider(constraints),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildEditButton(),
        ],
      ),
    );
  }

  List<Widget> getPersonItemList(BoxConstraints boxConstrains) {
    List<Widget> listWidgets = new List();

    for (int i = 0; i < widget.numPersons; ++i) {
      listWidgets.add(PersonItem(
          personID: 'Person $i',
          money: widget.billAmount * percentageList[i],
          height: boxConstrains.maxHeight * percentageList[i]));
    }
    return listWidgets;
  }

  List<Widget> getButtonSlider(BoxConstraints boxConstrains) {
    List<Widget> listWidgets = new List();

    double accumulativeDistance = 0.0;
    double height = boxConstrains.maxHeight * 0.11;

    for (int i = 0; i < widget.numPersons - 1; ++i) {
      accumulativeDistance += boxConstrains.maxHeight * percentageList[i];

      // Button to slide
      listWidgets.add(
        Positioned(
            top: accumulativeDistance - height / 2.0,
            right: 12.0,
            height: height,
            width: height,
            child: IconButton(
              icon: Icon(Icons.control_point),
              iconSize: height / 2.0,
              alignment: Alignment.center,
            )),
      );

      // Line to slide
      // Button to slide
      listWidgets.add(Positioned(
        top: accumulativeDistance - height / 2.0,
        child: Container(
          height: boxConstrains.maxHeight * 0.02,
          constraints: BoxConstraints.expand(),
          color: Colors.black87,
        ),
      ));
    }
    return listWidgets;
  }

  Widget buildEditButton() {
    double radius = 42.0;
    return InkWell(
      child: Hero(
        tag: 'splitBillButton_hero',
        child: Container(
          height: radius,
          width: 2.0 * radius,
          child: CustomPaint(
              painter: SemiCirclePainter(semiCircleColor: Theme.of(context).primaryColor, radius: radius),
              child: Icon(
                Icons.edit,
                size: 32.0,
              )),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(true);
      },
    );
  }

  Widget buildTotalAmountBox(Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 10.0, right: 10.0),
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
                  Text('\$${widget.billAmount + widget.billAmount * widget.tipPercentage}',
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
                        child: Text('TIPS(' + (widget.tipPercentage * 100).toInt().toString() + '%)',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(widget.billAmount.toString(),
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(widget.numPersons.toString(),
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text('\$${(widget.billAmount * widget.tipPercentage).toStringAsPrecision(3)}',
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

class SemiCirclePainter extends CustomPainter {
  Color semiCircleColor;
  double radius;

  SemiCirclePainter({this.semiCircleColor, this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint semiCirclePaint = Paint()..color = semiCircleColor;
    canvas.drawCircle(Offset(size.width / 2.0, size.height), radius, semiCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PersonItem extends StatelessWidget {
  final String personID;
  final double money;
  final double height;

  const PersonItem({Key key, this.personID, this.money, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$personID',
            style: TextStyle(fontSize: 11.0),
          ),
          Text(
            '${money.toStringAsFixed(2)}\$',
            style: TextStyle(fontSize: 23.0),
          ),
        ],
      ),
    );
  }
}
