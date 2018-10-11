import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Color leftColor;
  final Color rightColor;
  final int maxNumPersons;
  final double defaultSliderPercent;
  final Function(double sliderPercent) onValueChanged;

  const CustomSlider(
      {Key key,
      this.leftColor,
      this.rightColor,
      this.maxNumPersons = 12,
      this.defaultSliderPercent = 0.5,
      this.onValueChanged})
      : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double sliderPercent;
  // Dragging data
  double startDragX;
  double startDragPercent;

  @override
  void initState() {
    super.initState();
    sliderPercent = widget.defaultSliderPercent;
  }

  void _onPanStart(DragStartDetails details) {
    startDragX = details.globalPosition.dx;
    startDragPercent = sliderPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dragDistance = startDragX - details.globalPosition.dx;
    final sliderWidth = context.size.width;
    final dragPercent = dragDistance / sliderWidth;

    setState(() {
      sliderPercent = (startDragPercent - dragPercent).clamp(1.0 / widget.maxNumPersons, 1.0);
    });
    widget.onValueChanged(sliderPercent);
  }

  void _onPanEnd(DragEndDetails details) {
    double closestPercentage = -1.0;
    for (int persons = 1; persons <= widget.maxNumPersons; ++persons) {
      if ((persons / widget.maxNumPersons - sliderPercent).abs() < (closestPercentage - sliderPercent).abs()) {
        closestPercentage = persons / widget.maxNumPersons;
      }
    }

    setState(() {
      startDragX = null;
      startDragPercent = null;
      sliderPercent = closestPercentage;
    });
    widget.onValueChanged(sliderPercent);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            Center(
              child: Container(height: constraints.maxHeight - 10.0, color: widget.rightColor),
            ),
            ClipRect(
              clipper: new SliderClipper(sliderPercent: sliderPercent),
              child: Stack(
                children: <Widget>[
                  Container(
                    color: widget.leftColor,
                  )
                ],
              ),
            ),
            Positioned(
              left: constraints.maxWidth * sliderPercent,
              child: Container(
                width: constraints.maxWidth * 0.02,
                height: constraints.maxHeight * 1.1,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: new Text((widget.maxNumPersons * sliderPercent).toInt().toString(),
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class SliderClipper extends CustomClipper<Rect> {
  final sliderPercent;

  SliderClipper({this.sliderPercent});

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(0.0, 5.0, size.width * sliderPercent, size.height - 5.0);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
