import 'package:url_launcher/url_launcher.dart';

class ContactService {
  static const String whatsappNumber = '213770085877';

  static const String messengerUrl =
      'https://www.facebook.com/profile.php?id=61583967781975&locale=ar_AR';

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

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }

  static Future<bool> openMessenger() async {
    final Uri uri = Uri.parse(messengerUrl);

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
}