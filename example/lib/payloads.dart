import 'package:flutter/material.dart';
import 'package:notification_demo/pages/cart_page.dart';
import 'package:notification_demo/pages/checkout_page.dart';
import 'package:notification_demo/pages/default_page.dart';
import 'package:notification_demo/pages/payment_page.dart';
import 'package:simple_push_notification/simple_push_notification.dart';

class CartPayload extends NotificationPayload {
  final String cartId;

  CartPayload(this.cartId);
  @override
  void trigger(BuildContext router) {
    Navigator.push(
      router,
      MaterialPageRoute(
        builder: (context) => CartPage(id: cartId),
      ),
    );
  }
}

class PaymentPayload extends NotificationPayload {
  final String paymentId;

  PaymentPayload(this.paymentId);
  @override
  void trigger(BuildContext router) {
    Navigator.push(
      router,
      MaterialPageRoute(
        builder: (context) => PaymentPage(id: paymentId),
      ),
    );
  }
}

class CheckoutPayload extends NotificationPayload {
  @override
  void trigger(BuildContext router) {
    Navigator.push(
      router,
      MaterialPageRoute(
        builder: (context) => const CheckoutPage(),
      ),
    );
  }
}

class DefaultPayload extends NotificationPayload {
  @override
  void trigger(BuildContext router) {
    Navigator.push(
      router,
      MaterialPageRoute(
        builder: (context) => const DefaultPage(),
      ),
    );
  }
}
