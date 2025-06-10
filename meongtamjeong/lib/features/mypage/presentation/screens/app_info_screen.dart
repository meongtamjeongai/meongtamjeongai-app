import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppInfoWebViewScreen extends StatefulWidget {
  const AppInfoWebViewScreen({super.key});

  @override
  State<AppInfoWebViewScreen> createState() => _AppInfoWebViewScreenState();
}

class _AppInfoWebViewScreenState extends State<AppInfoWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://enormous-python-292.notion.site/20e922f5d3c280888b7fccd253cb2693',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('앱 정보')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
