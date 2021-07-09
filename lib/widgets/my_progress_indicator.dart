import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {

  final double progressSize;

  const MyProgressIndicator({Key key, this.progressSize = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: progressSize,
        width: progressSize,
        child: Image.asset('assets/images/loading_img_2.gif',)
      ),
    );
  }
}
