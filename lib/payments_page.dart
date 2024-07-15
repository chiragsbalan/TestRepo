import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late Razorpay _razorpay;
  List<Map<String, String>> _pendingPayments = [
    {'title': 'Charity Donation', 'description': 'Support the local charity'},
    {'title': 'Trip Payment', 'description': 'Field trip to the museum'}
  ];
  List<Map<String, String>> _completedPayments = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _completedPayments.add(_pendingPayments.removeAt(0));
    });
    _showDialog('Payment Successful', 'Your payment was successful.');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showDialog('Payment Failed', 'Error: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showDialog('External Wallet', 'External Wallet: ${response.walletName}');
  }

  void _makePayment(String title, String description) {
    var options = {
      'key': 'rzp_test_6rXArFbFfqZeaK', // Replace with your test key ID
      'amount': 100, // Amount in paise (10000 paise = 100 INR)
      'name': title,
      'description': description,
      'prefill': {
        'contact': '9008485696',
        'email': 'lenageok123@gmail.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Payments to be made:', style: TextStyle(fontSize: 20)),
          ),
          ..._pendingPayments.map((payment) {
            return ListTile(
              title: Text(payment['title']!),
              subtitle: Text(payment['description']!),
              trailing: Icon(Icons.payment),
              onTap: () => _makePayment(payment['title']!, payment['description']!),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Completed Payments:', style: TextStyle(fontSize: 20)),
          ),
          ..._completedPayments.map((payment) {
            return ListTile(
              title: Text(payment['title']!),
              subtitle: Text(payment['description']!),
              trailing: Icon(Icons.done),
            );
          }).toList(),
        ],
      ),
    );
  }
}
