// webview_screen.dart (Updated)
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import '../components/loading_indicator.dart';
import '../components/circular_menu.dart';
import '../components/live_button.dart';
import '../components/custom_bottom_bar.dart';
import 'home_screen.dart';

class WebViewScreen extends StatefulWidget {
  final String? url;

  const WebViewScreen({super.key, this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  static const String _defaultInitialUrl = 'https://talenttv.lk/#/mobile/';
  static const String _livePageUrl = 'https://talenttv.lk/#/multi-player';
  static const String _livePageIdentifier = 'multi-player';

  bool _isLoading = true;
  bool _canGoBack = false;
  late String _currentUrl;
  bool _showMenu = false;

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.live_tv,
      'label': 'About Us',
      'url': 'https://talenttv.lk/#/aboutus',
    },
    {
      'icon': Icons.calendar_today,
      'label': 'Fixtures',
      'url': 'https://talenttv.lk/#/fixtures',
    },
    {
      'icon': Icons.highlight_outlined,
      'label': 'Highlights',
      'url': 'https://talenttv.lk/#/highlights',
    },
    {
      'icon': Icons.web_stories,
      'label': 'Blogs',
      'url': 'https://talenttv.lk/#/blogs',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url ?? _defaultInitialUrl;
    _initializeWebView();
  }

  void _initializeWebView() {
    // 🚀 CRITICAL FIX for 'WebViewPlatform.instance != null' assertion.
    // This ensures the platform implementation is registered if it hasn't been already.
    if (WebViewPlatform.instance == null) {
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        // Use WKWebView for iOS/macOS
        WebViewPlatform.instance = WebKitWebViewPlatform();
      } else {
        // Use AndroidWebViewPlatform for Android
        WebViewPlatform.instance = AndroidWebViewPlatform();
      }
    }

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const {},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(_createNavigationDelegate())
      ..loadRequest(Uri.parse(_currentUrl));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  NavigationDelegate _createNavigationDelegate() {
    return NavigationDelegate(
      onProgress: (int progress) {
        debugPrint('WebView is loading (progress: $progress%)');
      },
      onPageStarted: (String url) {
        debugPrint('Page started loading: $url');
        setState(() {
          _isLoading = true;
          _currentUrl = url;
          _updateBackButton();
        });
      },
      onPageFinished: (String url) {
        debugPrint('Page finished loading: $url');
        setState(() {
          _isLoading = false;
          _updateBackButton();
        });
        _injectCSS();
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint('''
        Page resource error:
          code: ${error.errorCode}
          description: ${error.description}
          errorType: ${error.errorType}
          isForMainFrame: ${error.isForMainFrame}
        ''');
      },
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          debugPrint('blocking navigation to ${request.url}');
          return NavigationDecision.prevent;
        }
        debugPrint('allowing navigation to ${request.url}');
        return NavigationDecision.navigate;
      },
      onUrlChange: (UrlChange change) {
        if (change.url != null) {
          setState(() {
            _currentUrl = change.url!;
            _updateBackButton();
          });
        }
      },
    );
  }

  void _injectCSS() {
    const String css = '''
      .header-mobile, footer, .footer-menu { display: none !important; }
      body { padding-bottom: 0 !important; }
    ''';
    _controller.runJavaScript(
        'var style = document.createElement("style"); style.innerHTML = "$css"; document.head.appendChild(style);');
  }

  void _updateBackButton() async {
    final bool canGoBack = await _controller.canGoBack();
    if (mounted) {
      setState(() {
        _canGoBack = canGoBack;
      });
    }
  }

  void _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  void _handleMenuItemTap(String url) {
    setState(() {
      _showMenu = false;
    });
    _controller.loadRequest(Uri.parse(url));
  }

  bool get _isLivePage => _currentUrl.contains(_livePageIdentifier);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final viewPadding = MediaQuery.of(context).viewPadding;
    final isTablet = screenWidth >= 600;

    // Responsive positioning for LIVE button
    final liveButtonBottom = isTablet ? 120.0 : 100.0;
    final liveButtonRight = isTablet ? 24.0 : 16.0;

    return PopScope(
      canPop: !_canGoBack,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          await _controller.goBack();
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // WebView with proper padding for system UI
            Positioned.fill(
              top: viewPadding.top,
              child: WebViewWidget(controller: _controller),
            ),
            if (_isLoading) const LoadingIndicator(),
            if (_showMenu)
              CircularMenu(
                menuItems: _menuItems,
                onMenuItemTap: _handleMenuItemTap,
                onDismiss: () {
                  setState(() {
                    _showMenu = false;
                  });
                },
              ),
            if (!_isLivePage && !_showMenu)
              Positioned(
                bottom: liveButtonBottom + viewPadding.bottom,
                right: liveButtonRight,
                child: LiveButton(
                  onTap: () {
                    _controller.loadRequest(Uri.parse(_livePageUrl));
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: _isLivePage
            ? null
            : CustomBottomBar(
          canGoBack: _canGoBack,
          onBackPressed: _goBack,
          onForwardPressed: () async {
            if (await _controller.canGoForward()) {
              await _controller.goForward();
            }
          },
          onMenuPressed: () {
            setState(() {
              _showMenu = !_showMenu;
            });
          },
          onReloadPressed: () => _controller.reload(),
          onHomePressed: () {
            // Note: This navigates back to the HomeScreen and removes all previous routes.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
          showMenu: _showMenu,
        ),
      ),
    );
  }
}