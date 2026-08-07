import 'dart:js_interop';

@JS('gtag')
external void _gtag(JSString command, JSString eventName);

@JS('fbq')
external void _fbq(JSString command, JSString eventName);

class AnalyticsTracker {
  static void trackEvent(String eventName) {
    // Google Analytics
    try {
      _gtag('event'.toJS, eventName.toJS);
    } catch (_) {
      // Analytics must never prevent contact buttons from working.
    }

    // Meta Pixel
    try {
      if (eventName == 'whatsapp_click' ||
          eventName == 'messenger_click') {
        _fbq('track'.toJS, 'Contact'.toJS);
      }
    } catch (_) {
      // Meta Pixel must never prevent contact buttons from working.
    }
  }
}
