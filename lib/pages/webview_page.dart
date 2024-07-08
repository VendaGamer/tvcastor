import 'package:flutter/material.dart';
import 'package:webview_universal/webview_universal.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _webViewController = WebViewController();
  bool isBusy = false;
  @override
  void initState() {
    super.initState();
    _webViewController.init(
      context: context,
      setState: setState,
      uri: Uri.parse('https://prehrajto.cz'),
    );
  }

  void findMedia() async {
    String js = '''
  (function() {
    const mediaElements = [];

    // Get all image elements
    const images = document.querySelectorAll('img');
    images.forEach(img => {
      mediaElements.push({
        type: 'image',
        src: img.src
      });
    });

    // Get all video elements
    const videos = document.querySelectorAll('video');
    videos.forEach(video => {
      const sources = [];
      if (video.src) {
        sources.push(video.src);
      }
      video.querySelectorAll('source').forEach(source => {
        sources.push(source.src);
      });
      mediaElements.push({
        type: 'video',
        sources: sources
      });
    });

    // Get all audio elements
    const audios = document.querySelectorAll('audio');
    audios.forEach(audio => {
      const sources = [];
      if (audio.src) {
        sources.push(audio.src);
      }
      audio.querySelectorAll('source').forEach(source => {
        sources.push(source.src);
      });
      mediaElements.push({
        type: 'audio',
        sources: sources
      });
    });

    return mediaElements;
  })();
''';
    if (_webViewController.is_desktop) {
      var result = await _webViewController.webview_desktop_controller
          .evaluateJavaScript(js);
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
      final _webView= WebView(
        controller: _webViewController,
      ).createElement();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: findMedia,
        child: const Icon(Icons.search),
      ),
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      body: ,
    );
  }
}
