import 'package:flutter/material.dart';

class CustomRadioItem extends StatefulWidget {
  final String text;
  final bool isSelected;

  const CustomRadioItem({Key key, this.text, this.isSelected}) : super(key: key);

  @override
  _CustomRadioItemState createState() => _CustomRadioItemState();
}

class _CustomRadioItemState extends State<CustomRadioItem> {

  @override
  Widget build(BuildContext context) {
//    print("Reprint ")
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 60.0,
        height: 30.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: widget.isSelected ? Theme.of(context).primaryColor : Colors.grey,
              width: 1.7,
            )),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
