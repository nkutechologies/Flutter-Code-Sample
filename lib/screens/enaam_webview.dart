import 'package:enaam/screens/enaam_bottom_nav.dart';
import 'package:enaam/screens/thanks.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EnaamWebview extends StatefulWidget {
  final String url;
  const EnaamWebview({Key? key, required this.url}) : super(key: key);

  @override
  _EnaamWebviewState createState() => _EnaamWebviewState();
}

class _EnaamWebviewState extends State<EnaamWebview> {
  var _isApiCalled = false;
  var _isloading = true;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // #enddocregion platform_features
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              _isloading = false;
            });
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
            print('request urls | ' + request.url);
            if(request.url.contains('paymentsuccess.php')){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => ThanksScreen()), (Route route) => false);
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
            if(change.url!.contains('paymentsuccess.php')){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => ThanksScreen()), (Route route) => false);
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: _buildSmallScreen(size)),
    );
  }

  Widget _buildSmallScreen(
      Size size,
      ) {
    return _isApiCalled
        ? _buildSpinner(size)
        : _buildMainBody(
      size,
    );
  }

  Widget _buildSpinner(Size size) {
    return Center(
      child: SizedBox(
        width: size.width * 0.1,
        height: size.width * 0.1,
        child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Color(0xFF516365),
          strokeWidth: 5,
        ),
      ),
    );
  }

  _buildMainBody(Size size) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController)
        /*WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (value){
          //print(value);
        },
        onPageFinished: (value){
          print('Page Finished');
        setState(() {
          _isloading = false;
        });
        },
        navigationDelegate: (request){
          print('request urls');
          if(request.url.contains('paymentsuccess.php')){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => ThanksScreen()), (Route route) => false);
          }
          return NavigationDecision.navigate;
        },
      )*/,
          _isloading ? Center( child: CircularProgressIndicator(),)
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
