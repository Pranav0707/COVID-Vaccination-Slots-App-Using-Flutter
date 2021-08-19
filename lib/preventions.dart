import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Prevention extends StatelessWidget {
  Prevention({Key key}) : super(key: key);
  final stringurl =
      "https://www.cdc.gov/coronavirus/2019-ncov/prevent-getting-sick/prevention.html";
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Preventive Measures'),
              Opacity(
                opacity: 0,
                child: Container(
                    padding: EdgeInsets.symmetric(),
                    child: Icon(Icons.ac_unit)),
              )
            ],
          ),
          actions: <Widget>[
            Opacity(
              opacity: 0,
              child: Container(
                padding: EdgeInsets.symmetric(),
                child: Icon(Icons.save_alt),
              ),
            )
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebView(
              initialUrl: stringurl,
              onWebViewCreated: ((WebViewController webViewController) {
                _completer.complete(webViewController);
              }),
            )));
  }
}
