import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _userType;
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        supportZoom: false,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        allowContentAccess: false,
        geolocationEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
        scrollsToTop: false,
        allowsBackForwardNavigationGestures: false,
      ));
  @override
  void initState() {
    super.initState();
  }

  Future<String> getLocationPermission() async {
    /* final status = await Permission.location.request();
    if (status == PermissionStatus.permanentlyDenied) {
      Fluttertoast.showToast(
          msg: "Lütfen konum iznini verin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      openAppSettings();
      return "";
    }
    if (status == PermissionStatus.denied) {
      Fluttertoast.showToast(
          msg: "Lütfen konum iznini verin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      openAppSettings();
      return "";
    } */
    return Future.value("Done");
  }

  void _askPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.permanentlyDenied) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(
        url: Uri.parse(
            "https://publicresearch.herokuapp.com/96016b54-8676-41d3-aa21-fcfbf5cf51ea/mobile/cebd69cb-4151-4131-9ddd-1d02c6558448"),
      ));
      Fluttertoast.showToast(
          msg: "Lütfen konum iznini verin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      openAppSettings();
      return;
    }
    if (status == PermissionStatus.denied) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(
        url: Uri.parse(
            "https://publicresearch.herokuapp.com/96016b54-8676-41d3-aa21-fcfbf5cf51ea/mobile/cebd69cb-4151-4131-9ddd-1d02c6558448"),
      ));
      Fluttertoast.showToast(
          msg: "Lütfen konum iznini verin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      openAppSettings();
      return;
    }
  }

  /* void getUserType(cookieManager, url) async {
    Cookie? cookie = await cookieManager.getCookie(url: url, name: "usertype");
    setState(() {
      _userType =
          cookie?.value.toString().replaceAll("\\366", "ö").replaceAll('"', '');
    });
    return;
  } */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getLocationPermission(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data == "Done") {
              return InAppWebView(
                  initialOptions: options,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          'https://publicresearch.herokuapp.com/96016b54-8676-41d3-aa21-fcfbf5cf51ea/mobile/cebd69cb-4151-4131-9ddd-1d02c6558448')),
                  androidOnGeolocationPermissionsShowPrompt:
                      (InAppWebViewController controller, String origin) async {
                    return GeolocationPermissionShowPromptResponse(
                        origin: origin, allow: true, retain: true);
                  },
                  onUpdateVisitedHistory:
                      (controller, url, androidIsReload) async {
                    RegExp regExp = RegExp(
                        r"^https://publicresearch.herokuapp.com/survey/solve_survey_list\/(.*)\/");
                    if (regExp.hasMatch(url.toString())) {
                      _askPermission();
                    }
                    RegExp anketorRegExp = RegExp(
                        r"^https://publicresearch.herokuapp.com/user/single_user\/(.*)\/");
                    RegExp dashboardRegExp = RegExp(
                        r"^https://publicresearch.herokuapp.com/survey/view_dashboard\/(.*)\/");
                    if (anketorRegExp.hasMatch(url.toString()) ||
                        url.toString() ==
                            "https://publicresearch.herokuapp.com/survey/list/" ||
                        dashboardRegExp.hasMatch(url.toString())) {
                      CookieManager cookieManager = CookieManager.instance();
                      Cookie? cookie = await cookieManager.getCookie(
                          url: url!, name: "user_type");
                      debugPrint(cookie.toString());
                      debugPrint(cookie?.value.toString());
                      var userType =
                          cookie?.value.toString().replaceAll('"', '');
                      if (userType != "anketor") {
                        webViewController?.loadUrl(
                            urlRequest: URLRequest(
                          url: Uri.parse(
                              "https://publicresearch.herokuapp.com/user/logout/"),
                        ));
                        Fluttertoast.showToast(
                            msg: "Lütfen masaüstünden giriş yapın.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      // getUserType(cookieManager, url);
                    }
                  });
            } else {
              return ElevatedButton(
                onPressed: _askPermission,
                child: const Center(child: Text('Ask Permission')),
              );
            }
          } // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }
  /* Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest:
          URLRequest(url: Uri.parse('https://publicresearch.herokuapp.com')),
      androidOnGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
            origin: origin, allow: true, retain: true);
      },
    );
  } */

  /* Widget build(BuildContext context) {
    return const WebView(
      initialUrl: "http://192.168.1.113:8000", // "http://176.236.159.179/",
      javascriptMode: JavascriptMode.unrestricted,
    );
  } */
  /* Widget build(BuildContext context) {
    return const WebviewScaffold(
      url: "http://192.168.1.113:8000",
      withZoom: true,
      hidden: true,
      geolocationEnabled: true,
    );
  } */
}
