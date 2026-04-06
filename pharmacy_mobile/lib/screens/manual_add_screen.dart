import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManualAddScreen extends StatefulWidget {
  const ManualAddScreen({super.key});

  @override
  State<ManualAddScreen> createState() => _ManualAddScreenState();
}

class _ManualAddScreenState extends State<ManualAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _mfgController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int _quantity = 1;
  bool _isSaving = false;

  void _saveToCloud() async {
    if (_nameController.text.isEmpty || _batchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name and Batch are required!")));
      return;
    }
    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance.collection('inventory').doc("MAN_BC_${DateTime.now().millisecondsSinceEpoch}").set({
        'name': _nameController.text,
        'batch': _batchController.text,
        'mfg': _mfgController.text,
        'expiry': _expController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'quantity': _quantity,
        'last_updated': DateTime.now(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isSaving = false);
    }
  }

  Widget _buildField(String label, TextEditingController controller, {String hint = ""}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
          labelStyle: const TextStyle(color: Colors.tealAccent, fontSize: 14),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white10)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.tealAccent)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090E17),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Manual Intake", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 25),
            _buildField("Medicine Name", _nameController, hint: "e.g. Panadol Extra"),
            _buildField("Batch Code", _batchController, hint: "e.g. BTCH-9921"),
            Row(
              children: [
                Expanded(child: _buildField("MFG Date", _mfgController, hint: "MM/YYYY")),
                const SizedBox(width: 15),
                Expanded(child: _buildField("EXP Date", _expController, hint: "MM/YYYY")),
              ],
            ),
            _buildField("Unit Price (₹)", _priceController, hint: "0.00"),
            const SizedBox(height: 20),
            
            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity", style: TextStyle(color: Colors.white70, fontSize: 18)),
                Row(
                  children: [
                    IconButton(onPressed: () => setState(() => _quantity > 1 ? _quantity-- : 1), icon: const Icon(Icons.remove_circle, color: Colors.white38)),
                    Text("$_quantity", style: const TextStyle(color: Colors.tealAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => setState(() => _quantity++), icon: const Icon(Icons.add_circle, color: Colors.tealAccent)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.tealAccent, width: 1),
                  ),
                ),
                onPressed: _isSaving ? null : _saveToCloud,
                child: Text(_isSaving ? "SYNCING..." : "SAVE TO INVENTORY", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}