import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyWebViewScreen extends StatefulWidget {
  const PrivacyPolicyWebViewScreen({super.key});

  @override
  State<PrivacyPolicyWebViewScreen> createState() =>
      _PrivacyPolicyWebViewScreenState();
}

class _PrivacyPolicyWebViewScreenState
    extends State<PrivacyPolicyWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://enormous-python-292.notion.site/20e922f5d3c28065b902db24a08131b5',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보 처리방침')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
