import 'package:flutter/material.dart';

import '../../constants/web_colors.dart';

import 'package:provider/provider.dart';
import 'package:shared/shared.dart';

import 'dart:ui';

Future<bool?> showLoginDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const LoginDialog(),
  );
}

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final authProvider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

    final success = await authProvider.login(
      _idCtrl.text.trim(),
      _passCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      final user = authProvider.user;
      final String route;
      if (user != null && user.isAdmin) {
        route = '/admin';
      } else if (user != null && user.isStaff) {
        route = '/staff';
      } else {
        route = '/donor';
      }
      navigator.pop(true);
      navigator.pushNamedAndRemoveUntil(route, (_) => false);
    } else {
      setState(() => _error = authProvider.errorMessage ?? 'Login failed');
    }
  }

  String? _validateId(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Enter your username or email';
    if (value.contains('@')) {
      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
      if (!ok) return 'Enter a valid email address';
    } else if (value.length < 3) {
      return 'Username is too short';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter your password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, c) {
                    final wide = c.maxWidth >= 700;
                    if (!wide) {
                      return SingleChildScrollView(child: _formPanel());
                    }
                    return SizedBox(
                      height: 580,
                      child: Row(
                        children: [
                          const Expanded(flex: 5, child: _ImagePanel()),
                          Expanded(
                            flex: 6,
                            child: Center(
                              child: SingleChildScrollView(child: _formPanel()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close_rounded),
                    color: WebColors.textSecondary,
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _formPanel() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              'assets/images/milklink_logo.png',
              package: 'shared',
              height: 84,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome back',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: WebColors.primaryNavy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in to the MilkLink portal',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: WebColors.textSecondary),
          ),
          const SizedBox(height: 28),
          TextFormField(
            controller: _idCtrl,
            enabled: !_loading,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            validator: _validateId,
            decoration: _fieldDecoration(
              label: 'Username or email',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passCtrl,
            enabled: !_loading,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            validator: _validatePassword,
            onFieldSubmitted: (_) => _submit(),
            decoration: _fieldDecoration(
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              suffix: IconButton(
                tooltip: _obscure ? 'Show password' : 'Hide password',
                icon: Icon(_obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      size: 16, color: Color(0xFFDC2626)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_error!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFFB91C1C))),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: WebColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Sign In',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Authorized staff and registered donors only.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: WebColors.textMuted),
          ),
        ],
      ),
    ),
  );
}

  InputDecoration _fieldDecoration({
  required String label,
  required IconData icon,
  Widget? suffix,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    enabledBorder: border(const Color(0xFFE2E8F0)),
    focusedBorder: border(WebColors.primaryBlue, 1.8),
    errorBorder: border(Colors.redAccent),
    focusedErrorBorder: border(Colors.redAccent, 1.8),
        disabledBorder: border(const Color(0xFFE2E8F0)),
  );
}
}

class _ImagePanel extends StatelessWidget {
  const _ImagePanel();

  Widget _point(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 12.5, color: Colors.white, height: 1.3)),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/login.jpg',
          package: 'shared',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration:
                const BoxDecoration(gradient: WebColors.primaryGradient),
          ),
        ),
        // Blue silhouette: light at top, deep at bottom
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                WebColors.primaryBlue.withValues(alpha: 0.35),
                WebColors.primaryBlue.withValues(alpha: 0.65),
                WebColors.primaryNavy.withValues(alpha: 0.92),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Frosted message card
        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            ),
          ),
        ),
      ],
    );
  }}