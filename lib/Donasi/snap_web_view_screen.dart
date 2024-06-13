import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:nhcoree/Database/IpConfig.dart';

class SnapWebViewScreen extends StatefulWidget {
  static const routeName = '/snap-webview';

  const SnapWebViewScreen({Key? key}) : super(key: key);

  @override
  State<SnapWebViewScreen> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<SnapWebViewScreen> {
  var loadingPercentage = 0;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final url = routeArgs['url'];
    final nominal = routeArgs['nominal'];
    final tujuan = routeArgs['tujuan'];
    final name = routeArgs['name'];
    final phone = routeArgs['phone'];
    final email = routeArgs['email'];
    final doa = routeArgs['doa'];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            WebView(
              initialUrl: url,
              onPageStarted: (url) {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onProgress: (progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageFinished: (url) async {
                setState(() {
                  loadingPercentage = 100;
                });

                // Deteksi status transaksi dari URL
                if (url.contains('transaction_status=')) {
                  final uri = Uri.parse(url);
                  final transactionStatus =
                      uri.queryParameters['transaction_status'];
                  final orderId = uri.queryParameters['order_id'];

                  // Tampilkan status transaksi dan order_id di console
                  print('Transaction Status: $transactionStatus');
                  print('Order ID: $orderId');

                  if (transactionStatus == 'settlement' && orderId != null) {
                    // Kembali ke beranda
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home', // Ganti dengan route ke beranda Anda
                      (Route<dynamic> route) => false,
                    );

                    // Ambil token dari SharedPreferences
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? token = prefs.getString('token');
                    // Ambil id_donatur dari DatabaseHelper
                    String? id_donatur;
                    if (token != null) {
                      User? user = await DatabaseHelper.getUserFromLocal(token);
                      if (user != null) {
                        id_donatur = user.id_donatur;
                        print('id_donatur: $id_donatur');
                      }
                    }

                    // Pastikan id_donatur tidak null
                    if (id_donatur != null) {
                      // Kirim data transaksi ke backend
                      await sendTransactionData({
                        'order_id': orderId,
                        'nominal': nominal!,
                        'tujuan': tujuan!,
                        'name': name!,
                        'phone': phone!,
                        'email': email!,
                        'doa': doa!,
                        'id_donatur': id_donatur,
                        'transaction_time': DateTime.now().toString(),
                      });
                    }
                  }
                }
              },
              navigationDelegate: (navigation) {
                final host = Uri.parse(navigation.url).toString();
                if (host.contains('gojek://') ||
                    host.contains('shopeeid://') ||
                    host.contains('//wsa.wallet.airpay.co.id/') ||
                    host.contains('/gopay/partner/') ||
                    host.contains('/shopeepay/') ||
                    host.contains('/pdf')) {
                  _launchInExternalBrowser(Uri.parse(navigation.url));
                  return NavigationDecision.prevent;
                } else {
                  return NavigationDecision.navigate;
                }
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
            if (loadingPercentage < 100)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInExternalBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendTransactionData(Map<String, String> transactionData) async {
    const backendUrl = "${IpConfig.baseUrl}/api/handle-notification";

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionData),
    );

    if (response.statusCode == 200) {
      print('Transaction data sent successfully');
    } else {
      print(
          'Failed to send transaction data. Response status: ${response.statusCode}, body: ${response.body}');
    }
  }
}
