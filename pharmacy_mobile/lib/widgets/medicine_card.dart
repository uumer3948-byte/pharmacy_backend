import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {

  final Map medicine;
  final VoidCallback onAdd;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onAdd
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation:4,

      child: Padding(

        padding: const EdgeInsets.all(12),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Text(
              medicine["name"],
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height:10),

            Text("₹ ${medicine["selling_price"]}"),

            const SizedBox(height:10),

            ElevatedButton(
              onPressed: onAdd,
              child: const Text("Add")
            )

          ],

        ),

      ),

    );

  }

}