import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcrap/providers/auth_provider.dart';
import 'home_screen.dart';
import 'dart:async';

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

  // Add individual OTP controllers and focus nodes
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _loading = false;
  bool _otpSent = false;
  bool _isSignUp = false;
  int _countdown = 30;
  Timer? _timer;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    _nameCtrl.dispose();
    _otpFocus.dispose();
    // Dispose OTP controllers and focus nodes
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
    setState(() => _countdown = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // Simulate API call to send OTP
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      _loading = false;
      _otpSent = true;
    });

    _startCountdown();
    // Focus on first OTP box
    _otpFocusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent to +91 ${_phoneCtrl.text}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _verifyOTP() async {
    // Combine all OTP digits
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter 4-digit OTP'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_isSignUp && _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your name'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    // Simulate API call to verify OTP
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // For demo: accept any 4-digit OTP
    ref.read(authProvider.notifier).login();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));

    setState(() => _loading = false);
  }

  // New method to check if OTP is complete and auto-verify
  void _checkOTPComplete() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4 && !_loading) {
      // Add a small delay for better UX
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_loading) {
          _verifyOTP();
        }
      });
    }
  }

  Future<void> _resendOTP() async {
    if (_countdown > 0) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() => _loading = false);
    _startCountdown();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('OTP resent successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _editPhone() {
    setState(() {
      _otpSent = false;
      _otpCtrl.clear();
      // Clear all OTP boxes
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _timer?.cancel();
    });
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _otpSent = false;
      _otpCtrl.clear();
      // Clear all OTP boxes
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _timer?.cancel();
    });
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
                color: colorScheme.background,
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
                    // Header
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.phone_android_rounded,
                        color: colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      _otpSent
                          ? 'Verify OTP'
                          : _isSignUp
                          ? 'Sign Up'
                          : 'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      _otpSent
                          ? 'Enter the 4-digit code sent to\n+91 ${_phoneCtrl.text}'
                          : _isSignUp
                          ? 'Create your account with mobile number'
                          : 'Sign in with your mobile number',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Phone Number Input
                    if (!_otpSent) ...[
                      // Name field for sign up
                      if (_isSignUp) ...[
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
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
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.error),
                            ),
                          ),
                          validator: (v) {
                            if (_isSignUp && (v == null || v.trim().isEmpty)) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _sendOTP(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: 'Enter mobile number',
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: colorScheme.primary,
                          ),
                          prefixText: '+91 ',
                          counterText: '',
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter mobile number';
                          }
                          if (v.trim().length != 10) {
                            return 'Enter valid 10-digit number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            disabledBackgroundColor: colorScheme.primary
                                .withAlpha(128),
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
                                  'Send OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Toggle between Login and Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isSignUp
                                ? 'Already have an account? '
                                : "Don't have an account? ",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: _loading ? null : _toggleMode,
                            child: Text(
                              _isSignUp ? 'Login' : 'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // OTP Input - UPDATED with auto-verification
                    if (_otpSent) ...[
                      // OTP Input Fields (4 digits)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 50,
                            height: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (event) {
                                // Handle backspace for seamless deletion
                                if (event is RawKeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.backspace) {
                                  if (_otpControllers[index].text.isEmpty &&
                                      index > 0) {
                                    // Move to previous box and clear it
                                    _otpFocusNodes[index - 1].requestFocus();
                                    _otpControllers[index - 1].clear();
                                  }
                                }
                              },
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: colorScheme.surfaceVariant,
                                  contentPadding: EdgeInsets.zero,
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
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // Move to next box
                                    if (index < 3) {
                                      _otpFocusNodes[index + 1].requestFocus();
                                    } else {
                                      // Last box - unfocus and check if complete
                                      _otpFocusNodes[index].unfocus();
                                      _checkOTPComplete(); // Auto-verify when last digit is entered
                                    }
                                  } else if (value.isEmpty && index > 0) {
                                    // If field becomes empty, move back
                                    _otpFocusNodes[index - 1].requestFocus();
                                  }

                                  // Also check completion on any change (in case user pastes)
                                  if (value.isNotEmpty) {
                                    _checkOTPComplete();
                                  }
                                },
                                onTap: () {
                                  // Select all text when tapped
                                  _otpControllers[index].selection =
                                      TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            _otpControllers[index].text.length,
                                      );
                                },
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 24),

                      // Show loading indicator when auto-verifying
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

                      // Resend OTP
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

                      // Manual Verify Button (still available if needed)
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
                            disabledBackgroundColor: colorScheme.primary
                                .withAlpha(128),
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
                              : Text(
                                  _isSignUp
                                      ? 'Create Account'
                                      : 'Verify & Login',
                                  style: const TextStyle(
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

                    // Terms & Conditions
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
