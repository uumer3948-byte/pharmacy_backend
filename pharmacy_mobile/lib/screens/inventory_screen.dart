import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/scan_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  final nameController = TextEditingController();
  final batchController = TextEditingController();
  final mfgController = TextEditingController();
  final expController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  //--------------------------------
  // OCR CAMERA SCAN
  //--------------------------------

  Future scanMedicine() async {

    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.camera
    );

    if(image == null) return;

    var result = await ScanService.scanMedicine(image.path);

    setState(() {

      nameController.text = result["medicine_name"] ?? "";
      batchController.text = result["batch"] ?? "";
      mfgController.text = result["mfg_date"] ?? "";
      expController.text = result["exp_date"] ?? "";

    });

  }

  //--------------------------------
  // BARCODE SCANNER
  //--------------------------------

  void openBarcodeScanner(){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerPage(
          onDetect: (barcode){

            Navigator.pop(context);

            setState(() {
              nameController.text = "Detected Barcode: $barcode";
            });

          },
        ),
      ),
    );

  }

  //--------------------------------
  // SAVE INVENTORY
  //--------------------------------

  void saveInventory(){

    print(nameController.text);
    print(batchController.text);
    print(mfgController.text);
    print(expController.text);
    print(qtyController.text);
    print(priceController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Inventory Saved Successfully")
      )
    );

  }

  //--------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Inventory"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            //--------------------------------
            // SCAN BUTTONS
            //--------------------------------

            Row(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [

                ElevatedButton.icon(

                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Scan Medicine"),

                  onPressed: scanMedicine,

                ),

                ElevatedButton.icon(

                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Barcode"),

                  onPressed: openBarcodeScanner,

                ),

              ],

            ),

            const SizedBox(height:30),

            const Divider(),

            const SizedBox(height:20),

            //--------------------------------
            // FORM
            //--------------------------------

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Medicine Name"
              ),
            ),

            const SizedBox(height:15),

            TextField(
              controller: batchController,
              decoration: const InputDecoration(
                labelText: "Batch Number"
              ),
            ),

            const SizedBox(height:15),

            TextField(
              controller: mfgController,
              decoration: const InputDecoration(
                labelText: "MFG Date"
              ),
            ),

            const SizedBox(height:15),

            TextField(
              controller: expController,
              decoration: const InputDecoration(
                labelText: "EXP Date"
              ),
            ),

            const SizedBox(height:15),

            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity"
              ),
            ),

            const SizedBox(height:15),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price"
              ),
            ),

            const SizedBox(height:30),

            //--------------------------------
            // SAVE BUTTON
            //--------------------------------

            ElevatedButton(

              onPressed: saveInventory,

              child: const Text("Save Inventory"),

            )

          ],

        ),

      ),

    );

  }

}

//--------------------------------
// BARCODE SCANNER PAGE
//--------------------------------

class BarcodeScannerPage extends StatelessWidget {

  final Function(String) onDetect;

  const BarcodeScannerPage({
    super.key,
    required this.onDetect
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Scan Barcode"),
      ),

      body: MobileScanner(

        onDetect: (barcode, args){

          final String? code = barcode.rawValue;

          if(code != null){

            onDetect(code);

          }

        },

      ),

    );

  }

}