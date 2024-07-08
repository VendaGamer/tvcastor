import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isBusy = false;
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://prehrajto.cz'));

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
    final result = await _controller.runJavaScriptReturningResult(js);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: findMedia,
        child: const Icon(Icons.search),
      ),
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      body: Center(
        child: WebViewWidget(controller: _controller),
      ), //here is gonna be webView
    );
  }
}
