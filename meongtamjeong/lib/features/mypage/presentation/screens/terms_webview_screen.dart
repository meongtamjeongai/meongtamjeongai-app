import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsWebViewScreen extends StatefulWidget {
  const TermsWebViewScreen({super.key});

  @override
  State<TermsWebViewScreen> createState() => _TermsWebViewScreenState();
}

class _TermsWebViewScreenState extends State<TermsWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setUserAgent(
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
          )
          ..loadRequest(
            Uri.parse(
              'https://enormous-python-292.notion.site/20e922f5d3c280a8927be46adf025b4b',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '앱 이용 약관',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
