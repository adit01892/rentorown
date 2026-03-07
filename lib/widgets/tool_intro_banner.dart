import 'package:flutter/material.dart';

/// A collapsible info banner that introduces a tool and tells the user
/// what data they should have ready. Dismissible with an X button.
class ToolIntroBanner extends StatefulWidget {
  final String title;
  final String description;
  final List<String> dataNeeded;
  final IconData icon;

  const ToolIntroBanner({
    super.key,
    required this.title,
    required this.description,
    required this.dataNeeded,
    this.icon = Icons.lightbulb_outline,
  });

  @override
  State<ToolIntroBanner> createState() => _ToolIntroBannerState();
}

class _ToolIntroBannerState extends State<ToolIntroBanner>
    with SingleTickerProviderStateMixin {
  bool _dismissed = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) setState(() => _dismissed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final primary = Theme.of(context).colorScheme.primary;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.05),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.icon, color: primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: primary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _dismiss,
                  child: Icon(Icons.close, size: 18, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF616161),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: widget.dataNeeded.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 14,
                        color: primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
