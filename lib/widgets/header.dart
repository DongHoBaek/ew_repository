import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/common_size.dart';
import 'package:ttt_project_003/constant/screen_size.dart';

class Header extends StatelessWidget {
  String text;
  double padding;
  List<Widget> actions;

  Header(
      {Key key, @required this.text, this.padding = common_gap, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: padding, vertical: common_xl_gap),
      child: Container(
          width: size.width,
          child: Row(
            children: [
              Text(
                text,
                textAlign: TextAlign.start,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: font_size),
              ),
              Spacer(),
              actions != null
                  ? Row(
                      children: actions,
                    )
                  : Container()
            ],
          )),
    );
  }
}
