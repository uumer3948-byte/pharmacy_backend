import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/medicine_card.dart';
import '../widgets/cart_popup.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {

  List medicines = [];
  List cart = [];

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  void loadMedicines() async {

    var data = await ApiService.getMedicines();

    setState(() {
      medicines = data;
    });

  }

  void addToCart(med){

    setState(() {

      var existing = cart.where((c)=>c["id"]==med["id"]);

      if(existing.isNotEmpty){

        existing.first["qty"]++;

      } else {

        cart.add({
          "id":med["id"],
          "name":med["name"],
          "price":med["selling_price"],
          "qty":1
        });

      }

    });

  }

  int getTotal(){

    int total = 0;

    for(var c in cart){

      int price = (c["price"] as num).toInt();
      int qty = (c["qty"] as num).toInt();

      total += price * qty;

    }

    return total;

  }

  void openCart(){

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CartPopup(
        cart: cart,
        total: getTotal(),
      )
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Fanar Pharmacy POS"),
      ),

      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero,

          children: [

            const DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.green,
              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.local_pharmacy,
                    size: 40,
                    color: Colors.white,
                  ),

                  SizedBox(height:10),

                  Text(
                    "Fanar Pharmacy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                ],

              ),

            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: (){
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Add Inventory"),
              onTap: (){
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Orders"),
              onTap: (){
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Dashboard"),
              onTap: (){
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: (){
                Navigator.pop(context);
              },
            ),

          ],

        ),

      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openCart,
        icon: const Icon(Icons.shopping_cart),
        label: Text("Cart (${cart.length})"),
      ),

      body: GridView.builder(

        padding: const EdgeInsets.all(12),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3
        ),

        itemCount: medicines.length,

        itemBuilder: (context,i){

          return MedicineCard(
            medicine: medicines[i],
            onAdd: () => addToCart(medicines[i]),
          );

        },

      ),

    );

  }

}