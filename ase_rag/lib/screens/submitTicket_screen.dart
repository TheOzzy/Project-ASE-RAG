import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubmitTicketScreen extends StatefulWidget {
  const SubmitTicketScreen({super.key});

  @override
  State<SubmitTicketScreen> createState() => _SubmitTicketScreenState();
}

class _SubmitTicketScreenState extends State<SubmitTicketScreen> {
  final _supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();
  final _issueNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _priority; // High | Medium | Low
  String? _tag; // Screens | Printers | Networks | etc.

  bool _isSubmitting = false;

  static const indigo = Color(0xFF4F46E5);

  // Keep your tags close to your real-world categories
  final List<String> _tags = const [
    'Screens',
    'Printers',
    'Plotter Printer',
    'Plenary Projector',
    'CAP UI',
    'Networks',
    'Camera Equipment',
    'Millumin',
    'Other',
  ];

  final List<String> _priorities = const ['High', 'Medium', 'Low'];

  @override
  void dispose() {
    _issueNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_priority == null) {
      _showSnackBar('Please select a priority', isError: true);
      return;
    }
    if (_tag == null) {
      _showSnackBar('Please select a tag', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _supabase.from('tickets').insert({
        'issue_name': _issueNameController.text.trim(),
        'priority': _priority!,
        'description': _descriptionController.text.trim(),
        'tag': _tag!,
        // status intentionally omitted -> DB default 'undecided'
        // created_at intentionally omitted -> DB default now()
      });

      if (!mounted) return;

      _showSnackBar('Ticket submitted successfully!', isError: false);

      _issueNameController.clear();
      _descriptionController.clear();
      setState(() {
        _priority = null;
        _tag = null;
      });

      // go back to tickets screen / previous screen
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to submit ticket: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF6B7280)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Submit a Ticket',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  Card(
                    elevation: 0,
                    color: const Color(0xFFEEF2FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: indigo,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.support_agent, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Need Help?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Fill out the form below and our team will review it.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main form card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _Label('Issue Name'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _issueNameController,
                            maxLength: 120,
                            decoration: _inputDecoration(
                              hint: 'e.g. Screen 7 is flickering',
                              icon: Icons.title_outlined,
                            ),
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'Issue name is required';
                              if (value.length < 5) return 'Please enter at least 5 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          const _Label('Priority'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _priority,
                            decoration: _dropdownDecoration(icon: Icons.flag_outlined),
                            hint: const Text('Select priority'),
                            items: _priorities
                                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                .toList(),
                            onChanged: (v) => setState(() => _priority = v),
                          ),
                          const SizedBox(height: 16),

                          const _Label('Tag'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _tag,
                            decoration: _dropdownDecoration(icon: Icons.sell_outlined),
                            hint: const Text('Select tag'),
                            items: _tags.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (v) => setState(() => _tag = v),
                          ),
                          const SizedBox(height: 16),

                          const _Label('Description'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 7,
                            maxLength: 800,
                            decoration: _inputDecoration(
                              hint: 'Describe what happened, what you expected, and any steps to reproduce.',
                              icon: Icons.description_outlined,
                            ),
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'Description is required';
                              if (value.length < 20) return 'Please enter at least 20 characters';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        disabledBackgroundColor: const Color(0xFF9CA3AF),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Submit Ticket',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      'Tickets start as “undecided” until the team classifies them.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.25),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
      counterText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: indigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  InputDecoration _dropdownDecoration({required IconData icon}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: indigo, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '',
      style: TextStyle(),
    ).copyWith(
      // Hack-free label style without repeating constants everywhere
      // (still keeps your aesthetic)
    );
  }
}

extension on Widget {
  Widget copyWith({TextStyle? style}) {
    if (this is Text) {
      final t = this as Text;
      return Text(
        t.data ?? '',
        style: style ??
            const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
      );
    }
    return this;
  }
}
