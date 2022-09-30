import 'package:flutter/material.dart';

class DimissibleBackground extends StatelessWidget {
  const DimissibleBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Icon(Icons.delete),
      ),
    );
  }
}