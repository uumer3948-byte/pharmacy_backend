import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {

  const SuccessPopup({super.key});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      content: Column(

        mainAxisSize: MainAxisSize.min,

        children: const [

          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 70,
          ),

          SizedBox(height:20),

          Text(
            "Purchase Completed 🎉",
            style: TextStyle(
              fontSize:20,
              fontWeight: FontWeight.bold
            ),
          ),

          SizedBox(height:10),

          Text("Thank you!")

        ],

      ),

      actions: [

        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("OK")
        )

      ],

    );

  }

}