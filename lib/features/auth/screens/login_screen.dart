import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/otp_input.dart';
import '../widgets/phone_input.dart';
import '../widgets/loading_button.dart';
import 'package:dcrap/core/services/user_cache_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _otpFocus = FocusNode();

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  bool _otpSent = false;
  bool _isSignUp = false;
  int _countdown = 60;
  Timer? _timer;

  String? _verificationId;
  int? _resendToken;

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      final auth = FirebaseAuth.instance;
      debugPrint('✅ Firebase Auth initialized: ${auth.app.name}');
      debugPrint('✅ Current user: ${auth.currentUser?.uid ?? "None"}');
    } catch (e) {
      debugPrint('❌ Firebase connection error: $e');
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _nameCtrl.dispose();
    _otpFocus.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _countdown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _checkIfUserExists(String uid, String phone) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        setState(() => _isSignUp = true);
      } else {
        // Cache user data
        final userData = doc.data();
        if (userData != null) {
          await UserCacheService.saveUser(
            userId: uid,
            userName: userData['name'] ?? '',
            userPhone: phone,
          );
        }

        // StreamBuilder will automatically navigate when auth state changes
        // No need to manually navigate or call login()
      }
    } catch (e) {
      debugPrint('Error checking user: $e');
    }
  }

  Future<void> _saveUserData(String uid, String phone, String name) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving user data: $e');
      rethrow;
    }
  }

  Future<void> _sendOTP({bool isResend = false}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final phone = '+91${_phoneCtrl.text.trim()}';

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📱 Sending OTP to: $phone');
    debugPrint('🔄 Is resend: $isResend');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        forceResendingToken: isResend ? _resendToken : null,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint('✅ Verification completed automatically!');
          debugPrint('   SMS Code: ${credential.smsCode}');

          // Auto-fill OTP if available and OTP screen is visible
          if (credential.smsCode != null &&
              credential.smsCode!.length == 6 &&
              _otpSent) {
            debugPrint('   Filling OTP boxes: ${credential.smsCode}');
            for (var i = 0; i < 6; i++) {
              _otpControllers[i].text = credential.smsCode![i];
            }

            // Give UI time to update, then verify
            await Future.delayed(const Duration(milliseconds: 300));

            if (mounted && !_loading) {
              await _verifyOTP();
            }
            return;
          }

          // If no SMS code or OTP screen not shown, proceed with auto sign-in
          setState(() => _loading = true);
          try {
            final userCred = await FirebaseAuth.instance.signInWithCredential(
              credential,
            );

            debugPrint('✅ User signed in: ${userCred.user?.uid}');

            if (!mounted) return;

            await _checkIfUserExists(userCred.user!.uid, phone);
          } on FirebaseAuthException catch (e) {
            debugPrint('❌ Auto verification error: ${e.code} - ${e.message}');
            if (mounted) {
              _showErrorSnackbar(e.message ?? 'Verification failed');
            }
          } finally {
            if (mounted) setState(() => _loading = false);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          debugPrint('❌ Verification FAILED');
          debugPrint('   Code: ${e.code}');
          debugPrint('   Message: ${e.message}');
          debugPrint('   Phone: $phone');
          debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          if (mounted) {
            setState(() => _loading = false);
            String errorMessage = 'Verification failed';

            switch (e.code) {
              case 'invalid-phone-number':
                errorMessage = 'Invalid phone number format';
                break;
              case 'too-many-requests':
                errorMessage = 'Too many requests. Try again later';
                break;
              case 'quota-exceeded':
                errorMessage =
                    'SMS quota exceeded. Try test number: 9876543210';
                break;
              case 'network-request-failed':
                errorMessage = 'Network error. Check internet connection';
                break;
              case 'app-not-authorized':
                errorMessage =
                    'App not authorized. Add SHA fingerprint to Firebase';
                break;
              case 'missing-client-identifier':
                errorMessage =
                    'Missing app credentials. Check google-services.json';
                break;
              default:
                errorMessage = e.message ?? 'Unknown error occurred';
            }

            _showErrorSnackbar(errorMessage);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
          debugPrint('✅ CODE SENT!');
          debugPrint('   Verification ID: $verificationId');
          debugPrint('   Resend Token: $resendToken');
          debugPrint('   Phone: $phone');
          debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _resendToken = resendToken;
              _loading = false;
              _otpSent = true;
            });
            _startCountdown();
            _otpFocusNodes[0].requestFocus();
            _showSuccessSnackbar('OTP sent to $phone');
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('⏱️ Auto retrieval timeout');
          debugPrint('   Verification ID: $verificationId');
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('❌ EXCEPTION while sending OTP');
      debugPrint('   Error: $e');
      debugPrint('   Type: ${e.runtimeType}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      if (mounted) {
        setState(() => _loading = false);
        _showErrorSnackbar('Failed to send OTP: ${e.toString()}');
      }
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔐 Verifying OTP: $otp');
    debugPrint('   Verification ID: $_verificationId');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (otp.length != 6) {
      _showErrorSnackbar('Please enter 6-digit OTP');
      return;
    }

    if (_verificationId == null) {
      _showErrorSnackbar('Verification ID missing, please resend OTP');
      return;
    }

    setState(() => _loading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      debugPrint('📤 Signing in with credential...');
      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      debugPrint('✅ Sign in successful! UID: ${userCred.user?.uid}');

      if (!mounted) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .get();

      if (!doc.exists) {
        debugPrint('👤 New user - showing signup form');
        setState(() {
          _loading = false;
          _isSignUp = true;
        });
        return;
      }

      // Cache user data for existing users
      final userData = doc.data();
      if (userData != null) {
        final phone = '+91${_phoneCtrl.text.trim()}';
        await UserCacheService.saveUser(
          userId: userCred.user!.uid,
          userName: userData['name'] ?? '',
          userPhone: phone,
        );
      }

      if (!mounted) return;
      debugPrint('✅ Existing user - logging in');
      // StreamBuilder will automatically navigate when auth state changes
      setState(() => _loading = false);
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Verification error: ${e.code} - ${e.message}');

      if (mounted) {
        setState(() => _loading = false);
        String errorMessage = 'OTP verification failed';

        switch (e.code) {
          case 'invalid-verification-code':
            errorMessage = 'Invalid OTP. Please check and try again';
            break;
          case 'session-expired':
            errorMessage = 'OTP expired. Please request a new one';
            break;
          case 'invalid-verification-id':
            errorMessage = 'Session expired. Please resend OTP';
            break;
          default:
            errorMessage = e.message ?? 'Unknown error occurred';
        }

        _showErrorSnackbar(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ Exception during verification: $e');

      if (mounted) {
        setState(() => _loading = false);
        _showErrorSnackbar('An error occurred: ${e.toString()}');
      }
    }
  }

  Future<void> _completeSignup() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter your name');
      return;
    }

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not found');
      }

      final phone = '+91${_phoneCtrl.text.trim()}';
      final name = _nameCtrl.text.trim();

      await _saveUserData(user.uid, phone, name);

      // Cache user data
      await UserCacheService.saveUser(
        userId: user.uid,
        userName: name,
        userPhone: phone,
      );

      if (!mounted) return;

      // StreamBuilder will automatically navigate when auth state changes
      setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showErrorSnackbar('Failed to complete signup: ${e.toString()}');
      }
    }
  }

  void _checkOTPComplete() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 6 && !_loading) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_loading) {
          _verifyOTP();
        }
      });
    }
  }

  Future<void> _resendOTP() async {
    if (_countdown > 0) return;
    await _sendOTP(isResend: true);
  }

  void _editPhone() {
    setState(() {
      _otpSent = false;
      _isSignUp = false;
      _otpCtrl.clear();
      _verificationId = null;
      _resendToken = null;
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _timer?.cancel();
    });
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colorScheme.outline.withAlpha(51)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSignUp
                            ? Icons.person_add_rounded
                            : Icons.phone_android_rounded,
                        color: colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      _isSignUp
                          ? 'Complete Profile'
                          : _otpSent
                          ? 'Verify OTP'
                          : 'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _isSignUp
                          ? 'Please enter your name to continue'
                          : _otpSent
                          ? 'Enter the 6-digit code sent to\n+91 ${_phoneCtrl.text}'
                          : 'Sign in with your mobile number\n(Test: 9876543210, OTP: 123456)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (_isSignUp && _otpSent) ...[
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _completeSignup(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: colorScheme.primary,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withAlpha(51),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withAlpha(51),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _completeSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : const Text(
                                  'Complete Signup',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],

                    if (!_otpSent) ...[
                      PhoneInput(
                        controller: _phoneCtrl,
                        colorScheme: colorScheme,
                        onSubmit: _sendOTP,
                      ),
                      const SizedBox(height: 24),

                      LoadingButton(
                        isLoading: _loading,
                        onPressed: _sendOTP,
                        text: 'Send OTP',
                        colorScheme: colorScheme,
                      ),
                    ],

                    if (_otpSent && !_isSignUp) ...[
                      OtpInput(
                        controllers: _otpControllers,
                        focusNodes: _otpFocusNodes,
                        colorScheme: colorScheme,
                        onComplete: _checkOTPComplete,
                      ),

                      const SizedBox(height: 24),

                      if (_loading) ...[
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Verifying OTP...',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive code? ",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: _countdown > 0 || _loading
                                ? null
                                : _resendOTP,
                            child: Text(
                              _countdown > 0
                                  ? 'Resend in ${_countdown}s'
                                  : 'Resend OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _countdown > 0
                                    ? colorScheme.onSurfaceVariant.withAlpha(
                                        128,
                                      )
                                    : colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _loading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : const Text(
                                  'Verify & Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextButton.icon(
                        onPressed: _loading ? null : _editPhone,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Change mobile number'),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
