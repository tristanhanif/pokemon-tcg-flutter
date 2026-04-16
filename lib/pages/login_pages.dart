import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      username: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Berhasil")));
      context.go(AppRoutes.homePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? "Login gagal")),
      );
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username tidak boleh kosong";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Minimal 6 karakter";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [
          /// 🌌 Background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("assets/background.png", fit: BoxFit.cover),
          ),

          /// 🔵 Bottom Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF07123A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _buildFormContent(auth),
            ),
          ),

          /// ⚡ Pikachu Floating
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15 - (137 / 2),
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset("assets/pikachu.png", height: 137, width: 77),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 FORM CONTENT
  Widget _buildFormContent(AuthProvider auth) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            /// Title
          const Text(
            "Log In",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          /// Subtitle
          const Text(
            "Please sign in to continue",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),

          const SizedBox(height: 24),

          /// Username
          _buildInputField(
            controller: _emailController,
            hint: "Username Trainer",
            icon: Icons.person_outline,
            validator: _validateUsername,
          ),

          const SizedBox(height: 16),

          /// Password
          _buildInputField(
            controller: _passwordController,
            hint: "Password",
            icon: _isPasswordHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            isPassword: true,
            validator: _validatePassword,
          ),

          const SizedBox(height: 24),

          /// Button
          Center(
            child: SizedBox(
              width: 185,
              height: 47,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7573C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: auth.isLoading ? null : _handleLogin,
                child: auth.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// Forgot Password
          Center(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Forgot Password Page")),
                );
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Color(0xFFF7573C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),

          /// Bottom Text
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          context.go(AppRoutes.registerPath);
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color(0xFFF7573C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  /// 🔧 INPUT FIELD
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return Container(
      height: 63,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2345),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword ? _isPasswordHidden : false,
              style: const TextStyle(color: Colors.white),
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              if (isPassword) {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              }
            },
            child: Icon(icon, color: Colors.white70, size: 24),
          ),
        ],
      ),
    );
  }
}
