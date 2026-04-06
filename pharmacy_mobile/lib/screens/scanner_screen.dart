import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isProcessing = false;
  
  // Data Placeholders
  String medicineName = "Awaiting Capture...";
  String batchNo = "Detecting...";
  String expiryDate = "Detecting...";

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() {
        _isProcessing = true; // Lock the scanner
        // Simulated AI/Database Data for testing
        medicineName = "Amoxicillin 500mg"; 
        batchNo = "AMX-8992"; 
        expiryDate = "11/2026"; 
      });
      
      // Slight delay for visual satisfaction before the popup
      await Future.delayed(const Duration(milliseconds: 500));
      _showValidationPopup(barcodes.first.rawValue ?? "Unknown_Barcode");
    }
  }

  void _showValidationPopup(String scannedBarcode) {
    int quantity = 1;
    double price = 150.0; 
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A), 
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER ---
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.tealAccent, size: 28),
                      const SizedBox(width: 10),
                      const Text("Match Found", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54), 
                        onPressed: () { 
                          Navigator.pop(context); 
                          setState(() => _isProcessing = false); 
                        }
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(medicineName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 15),
                  
                  // --- BATCH & EXPIRY DATA ---
                  Row(
                    children: [
                      Expanded(child: _infoField("Batch No.", batchNo)), 
                      const SizedBox(width: 15), 
                      Expanded(child: _infoField("Expiry", expiryDate))
                    ]
                  ),
                  const SizedBox(height: 30),
                  
                  // --- QUANTITY SELECTOR ---
                  const Text("Enter Quantity Received", style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => setModalState(() => quantity > 1 ? quantity-- : 1), 
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.white, size: 32)
                      ),
                      Text("$quantity", style: const TextStyle(color: Colors.tealAccent, fontSize: 40, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () => setModalState(() => quantity++), 
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 32)
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // --- 1. THE GEN-Z ANIMATED SAVING BUTTON ---
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: isSaving 
                        ? [BoxShadow(color: Colors.tealAccent.withOpacity(0.6), blurRadius: 20, spreadRadius: 2)] 
                        : [],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaving ? const Color(0xFF134E4A) : const Color(0xFF0D9488), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: isSaving ? null : () async {
                        setModalState(() => isSaving = true); 

                        try {
                          await FirebaseFirestore.instance.collection('inventory').doc(scannedBarcode).set({
                            'name': medicineName, 
                            'batch': batchNo, 
                            'expiry': expiryDate, 
                            'price': price, 
                            'quantity': FieldValue.increment(quantity), 
                            'last_updated': DateTime.now(),
                          }, SetOptions(merge: true));
                          
                          if(context.mounted) {
                            Navigator.pop(context); 
                            Navigator.pop(context); 
                            
                            // --- 2. THE GEN-Z "CYBER-TOAST" BANNER ---
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    border: Border.all(color: Colors.tealAccent, width: 2), 
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [BoxShadow(color: Colors.tealAccent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                                  ),
                                  child: Row(
                                    children: [
                                      const Text("🚀", style: TextStyle(fontSize: 28)), 
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("STOCK SECURED", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5)),
                                            const SizedBox(height: 4),
                                            Text("+$quantity $medicineName synced to cloud.", style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        } catch (e) {
                          setModalState(() => isSaving = false); 
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red)
                          );
                        }
                      },
                      child: isSaving 
                        // Animated pulsing loader
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.tealAccent, strokeWidth: 3, strokeCap: StrokeCap.round)),
                              const SizedBox(width: 15),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.5, end: 1.0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: const Text("SYNCING TO CLOUD ✨", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 14)),
                                  );
                                },
                              ),
                            ],
                          )
                        : const Text("SAVE TO CLOUD INVENTORY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    ).whenComplete(() => setState(() => _isProcessing = false));
  }

  // Helper Widget for Data Fields
  Widget _infoField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)), 
          const SizedBox(height: 5), 
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Camera Feed
          MobileScanner(onDetect: _onDetect),
          
          // 2. Targeting Reticle
          Center(
            child: Container(
              width: 300, height: 200, 
              decoration: BoxDecoration(
                border: Border.all(color: _isProcessing ? Colors.teal : Colors.white54, width: 3), 
                borderRadius: BorderRadius.circular(20)
              )
            )
          ),
          
          // 3. Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0), 
              child: CircleAvatar(
                backgroundColor: Colors.black54, 
                child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context))
              )
            )
          ),
          
          // 4. Manual Capture Override Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: GestureDetector(
                onTap: () {
                  if (_isProcessing) return;
                  setState(() => _isProcessing = true);
                  // Bypasses the barcode requirement for manual entry testing
                  _showValidationPopup("MANUAL_ENTRY_${DateTime.now().millisecondsSinceEpoch}");
                },
                child: Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    shape: BoxShape.circle, 
                    border: Border.all(color: Colors.tealAccent, width: 4), 
                    boxShadow: [BoxShadow(color: Colors.tealAccent.withOpacity(0.5), blurRadius: 20)]
                  ),
                  child: const Center(child: Icon(Icons.camera_alt, color: Color(0xFF0F172A), size: 35)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}