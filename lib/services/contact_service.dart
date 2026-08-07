import 'package:url_launcher/url_launcher.dart';

import 'analytics_stub.dart'
if (dart.library.js_interop) 'analytics_web.dart';

class ContactService {
  static const String phoneNumber = '213770085877';

  static const String facebookPageUrl =
      'https://www.facebook.com/profile.php?id=61583967781975&locale=ar_AR';

  static Future<bool> openWhatsApp({
    required String product,
    required String brandName,
    required String designIdea,
  }) async {
    final message = '''
مرحبًا HILO PRINT 👋

أريد طلب تصميم/طباعة ملصق.

اسم المنتج: $product
اسم العلامة: $brandName

تفاصيل الطلب:
$designIdea
''';

    final Uri uri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    AnalyticsTracker.trackEvent('whatsapp_click');

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  static Future<bool> openFacebookPage() async {
    final Uri uri = Uri.parse(facebookPageUrl);

    AnalyticsTracker.trackEvent('facebook_click');

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
}
