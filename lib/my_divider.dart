import 'package:flutter/material.dart';


class MyDivider extends StatelessWidget {
  String texto;

  MyDivider(this.texto);
  @override
  Widget build(BuildContext context) {
      return Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Divider(
                color: Colors.blue,
                height: 50,
              )),
        ),

        Text(this.texto,
            style: TextStyle(color: Colors.blue)),

        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Divider(
                color: Colors.blue,
                height: 50,
              )),
        ),
      ]
      );
  }
}