import 'package:url_launcher/url_launcher.dart';

import 'analytics_stub.dart'
if (dart.library.js_interop) 'analytics_web.dart';

class ContactService {
  static const String whatsappNumber = '213770085877';

  static const String messengerUrl =
      'https://m.me/61583967781975';

  static String buildMessage({
    required String product,
    required String brandName,
    required String designIdea,
  }) {
    return '''
السلام عليكم HILO PRINT

أريد طلب تصميم وطباعة ملصق.

المنتج:
$product

اسم العلامة:
$brandName

فكرة التصميم:
$designIdea

سأرسل الشعار وصور المنتج داخل هذه المحادثة.
''';
  }

  static Future<bool> openWhatsApp({
    required String product,
    required String brandName,
    required String designIdea,
  }) async {
    final String message = buildMessage(
      product: product,
      brandName: brandName,
      designIdea: designIdea,
    );

    final Uri uri = Uri.parse(
      'https://wa.me/$whatsappNumber'
          '?text=${Uri.encodeComponent(message)}',
    );

    AnalyticsTracker.trackEvent('whatsapp_click');

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  static Future<bool> openMessenger() async {
    final Uri uri = Uri.parse(messengerUrl);

    AnalyticsTracker.trackEvent('messenger_click');

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
}
