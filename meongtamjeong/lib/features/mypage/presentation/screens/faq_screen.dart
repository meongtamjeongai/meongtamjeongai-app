import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FAQWebViewScreen extends StatefulWidget {
  const FAQWebViewScreen({super.key});

  @override
  State<FAQWebViewScreen> createState() => _FAQWebViewScreenState();
}

class _FAQWebViewScreenState extends State<FAQWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://enormous-python-292.notion.site/20e922f5d3c2802c8adfff46749280b7',
            ), // ← Notion URL
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자주 묻는 질문'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
