import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 🔥 VALIDATION
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Nama tidak boleh kosong";
    }
    if (value.length < 3) {
      return "Nama minimal 3 karakter";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email tidak boleh kosong";
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value)) {
      return "Format email tidak valid";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password tidak boleh kosong";
    }
    if (value != _passwordController.text) {
      return "Password tidak cocok";
    }
    return null;
  }

  /// 🔥 REGISTER HANDLER
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi Berhasil, Silakan Login")),
      );
      context.go(AppRoutes.loginPath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? "Registrasi gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

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
              height: screenHeight * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF020828),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: screenHeight * 0.85),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          _buildFormContent(auth),

                          if (auth.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade900.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  auth.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Center(
                              child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          context.go(AppRoutes.loginPath);
                                        },
                                        child: const Text(
                                          "Sign in",
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// � INPUT FIELD (FLOATING LABEL)
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
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
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _isPasswordHidden : false,
        style: const TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,

          /// Label style
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),

          /// Floating label style
          floatingLabelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),

          border: InputBorder.none,

          /// 🔥 ICON BALIK LAGI DI SINI
          suffixIcon: GestureDetector(
            onTap: () {
              if (isPassword) {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              }
            },
            child: Icon(icon, color: Colors.white70, size: 24),
          ),
        ),
      ),
    );
  }

  /// �� FORM CONTENT
  Widget _buildFormContent(AuthProvider auth) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            /// ⚡ Pikachu
            Center(
              child: Image.asset("assets/pikachu.png", height: 137, width: 77),
            ),

            const SizedBox(height: 16),

            /// Title
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            /// Subtitle
            const Text(
              "Please fill the details to continue",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),

            const SizedBox(height: 16),

            /// Name Field
            _buildInputField(
              controller: _nameController,
              label: "Nama Trainer",
              icon: Icons.person_outline,
              validator: _validateName,
            ),

            const SizedBox(height: 16),

            /// Email Field
            _buildInputField(
              controller: _emailController,
              label: "Email Trainer",
              icon: Icons.email_outlined,
              validator: _validateEmail,
            ),

            const SizedBox(height: 16),

            /// Password Field
            _buildInputField(
              controller: _passwordController,
              label: "Password",
              icon: _isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              isPassword: true,
              validator: _validatePassword,
            ),

            const SizedBox(height: 16),

            /// Confirm Password Field
            _buildInputField(
              controller: _confirmPasswordController,
              label: "Konfirmasi Password",
              icon: _isPasswordHidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              isPassword: true,
              validator: _validateConfirmPassword,
            ),

            const SizedBox(height: 24),

            /// Sign Up Button
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
                  onPressed: auth.isLoading ? null : _handleRegister,
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
