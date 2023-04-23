import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareApp {
  static void share(BuildContext context) async {
    final String text = 'Check out this cool app!';
    final String subject = 'Cool App';

    await Share.share(
      text,
      subject: subject,
    );
  }
  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(Uri.parse(url) as String);
    } else {
      throw 'Could not launch $url';
    }
  }


}
