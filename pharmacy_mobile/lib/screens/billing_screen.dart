import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  List<Map<String, dynamic>> _cart = [];
  bool _isScanning = false;
  double _total = 0.0;

  // AI TEXT SCANNER
  Future<void> _scanMedicine() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _isScanning = true);
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.isNotEmpty) {
        String query = recognizedText.text.split('\n').first;
        _searchController.text = query;
        _searchInFirebase(query);
      }
      await textRecognizer.close();
      setState(() => _isScanning = false);
    }
  }

  void _searchInFirebase(String q) async {
    var res = await FirebaseFirestore.instance
        .collection('inventory')
        .where('name', isGreaterThanOrEqualTo: q)
        .get();
    setState(() => _searchResults = res.docs);
  }

  void _addToCart(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    setState(() {
      _cart.add({'name': data['name'], 'price': data['price'], 'qty': 1});
      _total += data['price'];
      _searchResults = [];
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("SMART BILLING", style: TextStyle(fontWeight: FontWeight.w900))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              onChanged: _searchInFirebase,
              decoration: InputDecoration(
                hintText: "Search or Scan Medicine...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.camera_alt), onPressed: _scanMedicine),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(_searchResults[i]['name']),
                  trailing: const Icon(Icons.add_circle, color: Colors.teal),
                  onTap: () => _addToCart(_searchResults[i]),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(_cart[i]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("₹${_cart[i]['price']}"),
                trailing: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TOTAL: ₹$_total", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
                  onPressed: () {}, 
                  child: const Text("CHECKOUT"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}