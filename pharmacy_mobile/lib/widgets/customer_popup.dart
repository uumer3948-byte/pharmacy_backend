import 'package:flutter/material.dart';
import 'payment_popup.dart';

class CustomerPopup extends StatelessWidget {

  CustomerPopup({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text("Customer Details"),

      content: SingleChildScrollView(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Customer Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

          ],

        ),

      ),

      actions: [

        TextButton(

          onPressed: (){
            Navigator.pop(context);
          },

          child: const Text("Cancel")

        ),

        ElevatedButton(

          onPressed: (){

            Navigator.pop(context);

            showDialog(
              context: context,
              builder: (_) => const PaymentPopup(),
            );

          },

          child: const Text("Next")

        )

      ],

    );

  }

}