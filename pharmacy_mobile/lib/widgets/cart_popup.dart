import 'package:flutter/material.dart';
import 'customer_popup.dart';

class CartPopup extends StatelessWidget {

  final List cart;
  final int total;

  const CartPopup({
    super.key,
    required this.cart,
    required this.total
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),
      height: 450,

      child: Column(

        children: [

          const Text(
            "Cart",
            style: TextStyle(
              fontSize:22,
              fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height:20),

          Expanded(

            child: ListView.builder(

              itemCount: cart.length,

              itemBuilder:(context,i){

                var c = cart[i];

                return ListTile(
                  title: Text("${c["name"]} x${c["qty"]}"),
                  trailing: Text("₹ ${c["price"] * c["qty"]}")
                );

              },

            ),

          ),

          Text(
            "Total ₹ $total",
            style: const TextStyle(
              fontSize:20,
              fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height:15),

          ElevatedButton(

            onPressed: (){
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => CustomerPopup()
              );
            },

            child: const Text("Checkout")

          )

        ],

      ),

    );

  }

}