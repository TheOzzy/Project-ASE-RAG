import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'submitTicket_screen.dart'; // <-- change if your filename/class differs

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final _supabase = Supabase.instance.client;
  final _searchController = TextEditingController();

  String _statusFilter = 'all'; // all|undecided|red|amber|green
  bool _loading = true;

  List<Map<String, dynamic>> _tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();

    _searchController.addListener(() {
      setState(() {}); // re-filter locally
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    setState(() => _loading = true);
    try {
      final data = await _supabase
          .from('tickets')
          .select('id, issue_name, priority, description, tag, status, created_at')
          .order('created_at', ascending: false);

      _tickets = (data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      if (mounted) _showSnackBar('Failed to load tickets: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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

  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return '';
    final raw = createdAt.toString();
    return raw.length >= 10 ? raw.substring(0, 10) : raw;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'red':
        return const Color(0xFFEF4444);
      case 'amber':
        return const Color(0xFFF59E0B);
      case 'green':
        return const Color(0xFF10B981);
      case 'undecided':
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getStatusBgColor(String status) {
    final c = _getStatusColor(status);
    return c.withOpacity(0.15);
  }

  String _displayStatus(String status) {
    final s = status.toLowerCase();
    if (s == 'undecided') return 'Undecided';
    return s[0].toUpperCase() + s.substring(1);
  }

  List<Map<String, dynamic>> get _filteredTickets {
    final q = _searchController.text.trim().toLowerCase();

    return _tickets.where((t) {
      final status = (t['status'] ?? 'undecided').toString().toLowerCase();
      final title = (t['issue_name'] ?? '').toString().toLowerCase();
      final desc = (t['description'] ?? '').toString().toLowerCase();
      final tag = (t['tag'] ?? '').toString().toLowerCase();

      final statusOk = _statusFilter == 'all' ? true : status == _statusFilter;

      final searchOk = q.isEmpty ? true : (title.contains(q) || desc.contains(q) || tag.contains(q));

      return statusOk && searchOk;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterOption(
              title: 'All Tickets',
              isSelected: _statusFilter == 'all',
              onTap: () {
                setState(() => _statusFilter = 'all');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Undecided',
              color: const Color(0xFF6B7280),
              isSelected: _statusFilter == 'undecided',
              onTap: () {
                setState(() => _statusFilter = 'undecided');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Red Status',
              color: const Color(0xFFEF4444),
              isSelected: _statusFilter == 'red',
              onTap: () {
                setState(() => _statusFilter = 'red');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Amber Status',
              color: const Color(0xFFF59E0B),
              isSelected: _statusFilter == 'amber',
              onTap: () {
                setState(() => _statusFilter = 'amber');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Green Status',
              color: const Color(0xFF10B981),
              isSelected: _statusFilter == 'green',
              onTap: () {
                setState(() => _statusFilter = 'green');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTickets = _filteredTickets;

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
          'All Tickets',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF4F46E5)),
            onPressed: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, animation, __) => const TicketsScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 250),
                ),
              );

              // after submitting, reload list
              _fetchTickets();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTickets,
        child: Column(
          children: [
            // Search and Filter Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search tickets...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: Color(0xFF6B7280)),
                      onPressed: _showFilterDialog,
                    ),
                  ),
                ],
              ),
            ),

            // Tickets List
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
                      ),
                    )
                  : filteredTickets.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(
                              child: Text(
                                'No tickets found.',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredTickets.length,
                          itemBuilder: (_, index) {
                            return _TicketCard(
                              ticket: filteredTickets[index],
                              statusColor: _getStatusColor((filteredTickets[index]['status'] ?? 'undecided').toString()),
                              statusBg: _getStatusBgColor((filteredTickets[index]['status'] ?? 'undecided').toString()),
                              statusLabel: _displayStatus((filteredTickets[index]['status'] ?? 'undecided').toString()),
                              createdLabel: _formatDate(filteredTickets[index]['created_at']),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String title;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (color != null) ...[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final Color statusColor;
  final Color statusBg;
  final String statusLabel;
  final String createdLabel;

  const _TicketCard({
    required this.ticket,
    required this.statusColor,
    required this.statusBg,
    required this.statusLabel,
    required this.createdLabel,
  });

  @override
  Widget build(BuildContext context) {
    final title = (ticket['issue_name'] ?? '').toString();
    final id = (ticket['id'] ?? '').toString();
    final tag = (ticket['tag'] ?? '').toString();
    final priority = (ticket['priority'] ?? '').toString();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: $id',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.sell_outlined, size: 16, color: Color(0xFF6B7280)),
                  const SizedBox(width: 6),
                  Text(
                    tag.isEmpty ? 'No tag' : tag,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.flag_outlined, size: 16, color: Color(0xFF6B7280)),
                  const SizedBox(width: 6),
                  Text(
                    priority.isEmpty ? 'No priority' : priority,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const Spacer(),
                  Text(
                    createdLabel,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
