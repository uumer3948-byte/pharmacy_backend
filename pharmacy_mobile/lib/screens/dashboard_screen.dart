import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'scanner_screen.dart';
import 'billing_screen.dart';
import 'inventory_list_screen.dart';
import 'manual_add_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: const MenuScreen(),
      mainScreen: MainScreen(drawerController: _drawerController),
      borderRadius: 40.0,
      showShadow: true,
      angle: -10.0,
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      menuBackgroundColor: const Color(0xFF0F172A),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _showAddStockOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              const Text("CHOOSE INTAKE METHOD", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 30),
              _quickActionTile(context, "Scan with AI", "Auto-detect medicine", Icons.document_scanner_rounded, const Color(0xFF0D9488), const ScannerScreen()),
              const SizedBox(height: 15),
              _quickActionTile(context, "Type Details", "Manual entry mode", Icons.keyboard_alt_outlined, const Color(0xFF1E293B), const ManualAddScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActionTile(BuildContext context, String title, String sub, IconData icon, Color color, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
            const SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: CircleAvatar(radius: 35, backgroundColor: Color(0xFF0D9488), child: Icon(Icons.local_pharmacy, color: Colors.white, size: 35)),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: Text("Umar Hamid", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 40),
            _menuTile(context, Icons.grid_view_rounded, "Dashboard", true, null),
            _menuTile(context, Icons.inventory_2_outlined, "Inventory", false, const InventoryListScreen()),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => _showAddStockOptions(context),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0D9488).withOpacity(0.3)),
                  ),
                  child: const Row(children: [Icon(Icons.add_box_rounded, color: Color(0xFF0D9488)), SizedBox(width: 15), Text("Add Stock", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, bool active, Widget? destination) {
    return ListTile(
      leading: Icon(icon, color: active ? const Color(0xFF0D9488) : Colors.white54),
      title: Text(title, style: TextStyle(color: active ? Colors.white : Colors.white54)),
      onTap: () { if (destination != null) Navigator.push(context, MaterialPageRoute(builder: (context) => destination)); },
    );
  }
}

class MainScreen extends StatelessWidget {
  final ZoomDrawerController drawerController;
  const MainScreen({super.key, required this.drawerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.notes_rounded, color: Color(0xFF0F172A)), onPressed: () => drawerController.toggle?.call()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Financial Insights", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: _statCard("Total Sales", "₹85.4k", Icons.show_chart, Colors.teal)),
              const SizedBox(width: 15),
              Expanded(child: _statCard("Net Profit", "₹22.1k", Icons.account_balance_wallet, Colors.orange)),
            ]),
            const SizedBox(height: 25),
            _bentoAction(context, "Scan AI", Icons.document_scanner, const Color(0xFF0D9488), const ScannerScreen()),
            const SizedBox(height: 15),
            _bentoAction(context, "Live Billing POS", Icons.point_of_sale, Colors.blueAccent, const BillingScreen()),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String v, IconData i, Color c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(i, color: c), const Text(title, style: TextStyle(color: Colors.grey, fontSize: 12)), Text(v, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))]),
    );
  }

  Widget _bentoAction(BuildContext context, String t, IconData i, Color c, Widget d) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => d)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(25)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18)]),
      ),
    );
  }
}