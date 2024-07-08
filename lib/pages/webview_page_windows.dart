import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class WebViewPageWindows extends StatefulWidget {
  const WebViewPageWindows({super.key});

  @override
  State<WebViewPageWindows> createState() => _WebViewPageWindowsState();
}

class _WebViewPageWindowsState extends State<WebViewPageWindows> {
  bool isBusy = false;
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    try {
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl('https://prehrajto.cz');

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${e.code}'),
                      Text('Message: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Continue'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
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
    final result = await _controller.executeScript(js);
    print(result);
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
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
        child: Webview(
          _controller,
          permissionRequested: _onPermissionRequested,
        ),
      ), //here is gonna be webView
    );
  }
}
