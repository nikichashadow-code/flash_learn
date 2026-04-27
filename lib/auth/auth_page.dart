import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/l10n.dart';
import '../main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        final res = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (res.session != null) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else if (mounted) {
          setState(() => _errorMessage = context.l10n.loginFailed);
        }
      } else {
        final res = await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (res.user == null) {
          if (mounted) {
            setState(() => _errorMessage = context.l10n.signupFailed);
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.signUpSuccessCheckEmail)),
          );
        }
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.enterEmailAddress)));
      return;
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.passwordResetLinkSent)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorPrefix(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(scheme.primary, scheme.surface, 0.78)!,
                        Color.lerp(scheme.secondary, scheme.surface, 0.62)!,
                        Color.lerp(scheme.tertiary, scheme.surface, 0.86)!,
                      ],
                      stops: [0.1, 0.5 + (value * 0.1), 1],
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      tooltip: context.l10n.language,
                      icon: Icon(Icons.language, color: scheme.onSurface),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (sheetContext) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: Text(context.l10n.english),
                                  onTap: () {
                                    MyApp.controllerOf(
                                      context,
                                    ).setLocale(const Locale('en'));
                                    Navigator.pop(sheetContext);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: Text(context.l10n.bulgarian),
                                  onTap: () {
                                    MyApp.controllerOf(
                                      context,
                                    ).setLocale(const Locale('bg'));
                                    Navigator.pop(sheetContext);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.language),
                                  title: Text(context.l10n.swedish),
                                  onTap: () {
                                    MyApp.controllerOf(
                                      context,
                                    ).setLocale(const Locale('sv'));
                                    Navigator.pop(sheetContext);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.elasticOut,
                        tween: Tween(begin: 0.7, end: 1),
                        builder: (context, value, child) =>
                            Transform.scale(scale: value, child: child),
                        child: Icon(
                          Icons.flash_on,
                          color: scheme.primary,
                          size: 52,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.authBrand,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 48),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Text(
                          _isLogin
                              ? context.l10n.welcomeBack
                              : context.l10n.signUp,
                          key: ValueKey(_isLogin),
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isLogin
                            ? context.l10n.loginToContinue
                            : context.l10n.createAccountToContinue,
                        style: TextStyle(
                          color: scheme.onSurface.withAlpha((0.7 * 255).round()),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 36),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: scheme.error),
                          ),
                        ),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: scheme.onSurface),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: scheme.surface.withAlpha(
                            (0.86 * 255).round(),
                          ),
                          hintText: context.l10n.email,
                          hintStyle: TextStyle(
                            color: scheme.onSurface.withAlpha((0.6 * 255).round()),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: scheme.onSurface),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: scheme.surface.withAlpha(
                            (0.86 * 255).round(),
                          ),
                          hintText: context.l10n.password,
                          hintStyle: TextStyle(
                            color: scheme.onSurface.withAlpha((0.6 * 255).round()),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                            checkColor: scheme.onPrimary,
                            activeColor: scheme.primary,
                          ),
                          Text(
                            context.l10n.rememberMe,
                            style: TextStyle(color: scheme.onSurface),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _resetPassword,
                            child: Text(
                              context.l10n.forgotPassword,
                              style: TextStyle(
                                color: scheme.onSurface.withAlpha(
                                  (0.75 * 255).round(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                scale: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: scheme.primary,
                                    foregroundColor: scheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                  onPressed: _authenticate,
                                  child: Text(
                                    _isLogin
                                        ? context.l10n.login
                                        : context.l10n.signUp,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin
                                ? context.l10n.dontHaveAccount
                                : context.l10n.alreadyHaveAccount,
                            style: TextStyle(
                              color: scheme.onSurface.withAlpha(
                                (0.75 * 255).round(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _isLogin = !_isLogin);
                            },
                            child: Text(
                              _isLogin
                                  ? context.l10n.signUpLink
                                  : context.l10n.logInLink,
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
