import 'package:flutter/material.dart';

import '../../src/constants.dart';

class TextExpandWidget extends StatefulWidget {
  const TextExpandWidget({
    Key? key,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final String text;
  final Color textColor;

  @override
  State<TextExpandWidget> createState() => _TextExpandWidgetState();
}

class _TextExpandWidgetState extends State<TextExpandWidget> {
  late String firstHalf;
  late String lastHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    String text = widget.text;
    if (text.length > 50) {
      firstHalf = text.substring(0, 50);
      lastHalf = text.substring(50, text.length);
    } else {
      firstHalf = text;
      lastHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return lastHalf.isEmpty
        ? Text(
            firstHalf,
            style: CustomTextStyle.bodyText2.copyWith(color: widget.textColor),
          )
        : Column(
            children: <Widget>[
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.topCenter,
                child: Text(
                  flag ? (firstHalf + "...") : (firstHalf + lastHalf),
                  style: CustomTextStyle.bodyText2
                      .copyWith(color: widget.textColor),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Text(
                    flag ? "See more" : "Hide",
                    style: CustomTextStyle.title3
                        .copyWith(color: widget.textColor),
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ),
            ],
          );
  }
}
