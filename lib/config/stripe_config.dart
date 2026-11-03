import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeConfig {
  static String get publishableKey {
    final key = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('Set STRIPE_PUBLISHABLE_KEY in .env');
    }
    return key;
  }

  static String get backendUrl {
    final url = dotenv.env['BACKEND_URL'];
    if (url == null || url.isEmpty) {
      throw StateError('Set BACKEND_URL in .env');
    }
    return url;
  }
}