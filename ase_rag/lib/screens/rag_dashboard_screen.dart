import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RagDashboardScreen extends StatefulWidget {
  const RagDashboardScreen({super.key});

  @override
  State<RagDashboardScreen> createState() => _RagDashboardScreenState();
}

class _RagDashboardScreenState extends State<RagDashboardScreen> {
  final _supabase = Supabase.instance.client;

  bool _loading = true;

  int redCount = 0;
  int amberCount = 0;
  int greenCount = 0;
  int undecidedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _loading = true);

    try {
      final data = await _supabase.from('tickets').select('status');

      int r = 0, a = 0, g = 0, u = 0;
      for (final row in (data as List)) {
        final status = (row['status'] ?? 'undecided').toString().toLowerCase();
        if (status == 'red') r++;
        else if (status == 'amber') a++;
        else if (status == 'green') g++;
        else u++;
      }

      setState(() {
        redCount = r;
        amberCount = a;
        greenCount = g;
        undecidedCount = u;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load dashboard: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const indigo = Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('RAG Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadCounts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCounts,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Live counts from Supabase tickets table.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),

            // Count cards
            Row(
              children: [
                Expanded(
                  child: _CountCard(
                    title: 'Red',
                    count: redCount,
                    color: const Color(0xFFEF4444),
                    icon: Icons.error_outline,
                    loading: _loading,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CountCard(
                    title: 'Amber',
                    count: amberCount,
                    color: const Color(0xFFF59E0B),
                    icon: Icons.access_time,
                    loading: _loading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CountCard(
                    title: 'Green',
                    count: greenCount,
                    color: const Color(0xFF10B981),
                    icon: Icons.check_circle_outline,
                    loading: _loading,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CountCard(
                    title: 'Undecided',
                    count: undecidedCount,
                    color: const Color(0xFF6B7280),
                    icon: Icons.help_outline,
                    loading: _loading,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Bar chart placeholder
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bar Chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ticket counts by status (placeholder).',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      alignment: Alignment.center,
                      child: _loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(indigo),
                            )
                          : const Text(
                              'TODO: Add chart widget here',
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pie chart placeholder
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pie Chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Distribution of tickets by status (placeholder).',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      alignment: Alignment.center,
                      child: _loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(indigo),
                            )
                          : const Text(
                              'TODO: Add chart widget here',
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CountCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;
  final bool loading;

  const _CountCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  loading
                      ? Container(
                          height: 18,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )
                      : Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
