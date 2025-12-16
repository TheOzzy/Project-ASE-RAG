import 'package:flutter/material.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    // Replace this with Firebase Auth createUser later.
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF4F46E5);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEFF6FF),
              Color(0xFFE0E7FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo + Title
                          Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: indigo,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.confirmation_number_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Join your team on RAG Status',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Full name
                          _FieldLabel('Full Name'),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'John Doe',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: indigo,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if ((v ?? '').trim().isEmpty) return 'Full name is required';
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Email
                          _FieldLabel('Email'),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'you@company.com',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: indigo,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'Email is required';
                              if (!value.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Password
                          _FieldLabel('Password'),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: indigo,
                                  width: 2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            validator: (v) {
                              if ((v ?? '').isEmpty) return 'Password is required';
                              if ((v ?? '').length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Create account button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _createAccount,
                              child: const Text(
                                'Create Account',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Sign in link
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/login'),
                            child: const Text(
                              'Already have an account? Sign in',
                              style: TextStyle(color: indigo, fontSize: 13),
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
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}
