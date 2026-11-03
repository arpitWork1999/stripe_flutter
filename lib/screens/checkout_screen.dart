import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../services/payment_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const _amount = 1099;
  static const _currency = 'usd';

  final _payments = PaymentService();
  var _paying = false;
  String? _status;

  Future<void> _pay() async {
    setState(() {
      _paying = true;
      _status = null;
    });

    try {
      await _payments.pay(amount: _amount, currency: _currency);
      if (!mounted) return;
      setState(() => _status = 'Payment succeeded');
    } on StripeException catch (error) {
      if (!mounted) return;
      setState(() {
        _status = error.error.code == FailureCode.Canceled
            ? 'Payment canceled'
            : error.error.localizedMessage ?? 'Payment failed';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _status = error.toString());
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Demo item', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            const Text('\$10.99'),
            const Spacer(),
            if (_status != null) ...[
              Text(_status!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: _paying ? null : _pay,
              child: Text(_paying ? 'Opening payment…' : 'Pay \$10.99'),
            ),
          ],
        ),
      ),
    );
  }
}
