import 'package:flutter/material.dart';
import '../../constants/web_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';

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
                LayoutBuilder(builder: (context, c) {
                  final wide = c.maxWidth >= 700;
                  if (!wide) {
                    return SingleChildScrollView(child: _formPanel());
                  }
                  return SizedBox(
                    height: 540,
                    child: Row(children: [
                      const Expanded(child: _ImagePanel()),
                      Expanded(child: SingleChildScrollView(child: _formPanel())),
                    ]),
                  );
                }),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close_rounded),
                    color: WebColors.textSecondary,
                    onPressed: _loading ? null : () => Navigator.of(context).pop(),
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
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: WebColors.primaryBlue),
            ),
            const SizedBox(height: 4),
            const Text(
              'Login with username or email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: WebColors.textSecondary),
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
              const SizedBox(height: 12),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
            ],

            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 180,
                height: 46,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('LOGIN',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?",
                    style: TextStyle(fontSize: 12, color: WebColors.textSecondary)),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/become-a-donor');
                        },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Register Now',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
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
    OutlineInputBorder border(Color color, [double width = 1.2]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      enabledBorder: border(WebColors.waveBlue),
      focusedBorder: border(WebColors.primaryBlue, 1.8),
      errorBorder: border(Colors.redAccent),
      focusedErrorBorder: border(Colors.redAccent, 1.8),
      disabledBorder: border(WebColors.border),
    );
  }
}

/// Left image section.
/// Photo path: Shared\assets\images\login_banner.jpg
class _ImagePanel extends StatelessWidget {
  const _ImagePanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/login_banner.jpg',
          package: 'shared',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration:
                const BoxDecoration(gradient: WebColors.primaryGradient),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.45),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.25),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 40, 28, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MilkLink',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Pasig City Human Milk Bank.\nEvery drop gives a newborn a chance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: Colors.white, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}