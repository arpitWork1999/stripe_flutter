import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../config/stripe_config.dart';


class PaymentService {
  Future<void> pay({
    required int amount,
    required String currency,
  }) async {
    final clientSecret = await _createPaymentIntent(
      amount: amount,
      currency: currency,
    );

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Stripe Flutter',
        returnURL: 'flutterstripe://redirect',
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  Future<String> _createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    final response = await http.post(
      Uri.parse('${StripeConfig.backendUrl}/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Could not start payment (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final clientSecret = data['clientSecret'] as String?;
    if (clientSecret == null || clientSecret.isEmpty) {
      throw Exception('Server response did not include clientSecret');
    }
    return clientSecret;
  }
}