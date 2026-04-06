import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _verificationId = ""; 

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  late AnimationController _bgController;
  late AnimationController _pulseController; 

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pulseController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    // --- DEVELOPER BYPASS ---
    if (_otpController.text == "000000") {
      _goToDashboard();
      return;
    }

    if (_otpController.text.length == 6) { 
      setState(() { _isLoading = true; _pulseController.repeat(); });
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _otpController.text.trim(),
        );
        await _auth.signInWithCredential(credential);
        _goToDashboard();
      } catch (e) {
        setState(() { _isLoading = false; _pulseController.stop(); });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP"), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.length >= 10) {
      setState(() { _isLoading = true; _pulseController.repeat(); });
      
      String phoneNumber = "+91${_phoneController.text.trim()}";

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _goToDashboard();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() { _isLoading = false; _pulseController.stop(); });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Error"), backgroundColor: Colors.red));
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;
          });
          _pulseController.stop();
        },
        codeAutoRetrievalTimeout: (String verificationId) => _verificationId = verificationId,
      );
    }
  }

  void _goToDashboard() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedLogo(),
                  const SizedBox(height: 40),
                  const Text("Fanar Pharmacy", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                  const SizedBox(height: 40),
                  _buildInputFields(),
                  const SizedBox(height: 30),
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: const [Color(0xFF0D9488), Color(0xFF0F172A)],
              center: Alignment(_bgController.value * 2 - 1, _bgController.value * 2 - 1),
              radius: 1.5,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_isLoading) ...[
          _pulseRing(0.0),
          _pulseRing(0.5),
        ],
        Container(
          height: 160, width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.tealAccent.withOpacity(0.2), blurRadius: 40)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset('assets/logo.png', fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _pulseRing(double delay) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        double prog = (_pulseController.value + delay) % 1.0;
        return Container(
          width: 160 + (prog * 180),
          height: 160 + (prog * 180),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.tealAccent.withOpacity(1.0 - prog), width: 4 - (prog * 3)),
          ),
        );
      },
    );
  }

  Widget _buildInputFields() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: Colors.white24)
      ),
      child: TextField(
        controller: _isOtpSent ? _otpController : _phoneController,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 4),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: _isOtpSent ? "XXXXXX" : "Phone Number", 
          hintStyle: const TextStyle(color: Colors.white30, letterSpacing: 1), 
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.all(20)
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isLoading 
        ? const Text("Establishing Secure Connection...", style: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold))
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488), 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 18), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
              ),
              child: Text(_isOtpSent ? "VERIFY & ENTER" : "GET ACCESS CODE", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
    );
  }
}