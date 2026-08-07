import 'dart:js_interop';

@JS('gtag')
external void _gtag(JSString command, JSString eventName);

class AnalyticsTracker {
  static void trackEvent(String eventName) {
    try {
      _gtag('event'.toJS, eventName.toJS);
    } catch (_) {
      // Analytics must never prevent contact buttons from working.
    }
  }
}
