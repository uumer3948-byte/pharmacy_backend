import 'package:flutter/material.dart';
import 'success_popup.dart';

class PaymentPopup extends StatelessWidget {

  const PaymentPopup({super.key});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text("Select Payment Method"),

      content: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          ElevatedButton.icon(

            icon: const Icon(Icons.money),
            label: const Text("Cash"),

            onPressed: (){

              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (_) => SuccessPopup()
              );

            },

          ),

          const SizedBox(height:10),

          ElevatedButton.icon(

            icon: const Icon(Icons.qr_code),
            label: const Text("UPI"),

            onPressed: (){

              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (_) => SuccessPopup()
              );

            },

          ),

          const SizedBox(height:10),

          ElevatedButton.icon(

            icon: const Icon(Icons.credit_card),
            label: const Text("Card"),

            onPressed: (){

              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (_) => SuccessPopup()
              );

            },

          ),

        ],

      ),

    );

  }

}