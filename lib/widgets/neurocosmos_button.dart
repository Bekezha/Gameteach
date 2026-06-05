import 'package:flutter/material.dart';
import '../theme/neurocosmos_theme.dart';

class NeuroCosmosButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final double? width;
  final double? height;
  final bool is3D;
  final IconData? icon;

  const NeuroCosmosButton({
    super.key,
    required this.text,
    this.onPressed,
    this.accentColor,
    this.width,
    this.height,
    this.is3D = true,
    this.icon,
  });

  @override
  State<NeuroCosmosButton> createState() => _NeuroCosmosButtonState();
}

class _NeuroCosmosButtonState extends State<NeuroCosmosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? NeuroCosmosTheme.electricTurquoise;
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? _handleTapDown : null,
      onTapUp: isEnabled ? _handleTapUp : null,
      onTapCancel: isEnabled ? _handleTapCancel : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height ?? 56,
          decoration: widget.is3D
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isEnabled
                        ? [
                            accentColor.withValues(alpha: 0.8),
                            accentColor.withValues(alpha: 0.6),
                          ]
                        : [
                            Colors.grey.withValues(alpha: 0.5),
                            Colors.grey.withValues(alpha: 0.3),
                          ],
                  ),
                  boxShadow: isEnabled
                      ? [
                          // Main shadow
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          // Inner glow
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                            spreadRadius: 0,
                          ),
                          // 3D depth effect
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 12),
                            spreadRadius: -5,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isEnabled
                        ? [
                            accentColor.withValues(alpha: 0.6),
                            accentColor.withValues(alpha: 0.4),
                          ]
                        : [
                            Colors.grey.withValues(alpha: 0.4),
                            Colors.grey.withValues(alpha: 0.2),
                          ],
                  ),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NeuroCosmosIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final double size;
  final bool is3D;

  const NeuroCosmosIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.accentColor,
    this.size = 56,
    this.is3D = true,
  });

  @override
  State<NeuroCosmosIconButton> createState() => _NeuroCosmosIconButtonState();
}

class _NeuroCosmosIconButtonState extends State<NeuroCosmosIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? NeuroCosmosTheme.neonPink;
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => _controller.forward() : null,
      onTapUp: isEnabled ? (_) => _controller.reverse() : null,
      onTapCancel: isEnabled ? () => _controller.reverse() : null,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.is3D
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.2,
                    colors: isEnabled
                        ? [
                            accentColor.withValues(alpha: 0.9),
                            accentColor.withValues(alpha: 0.6),
                          ]
                        : [
                            Colors.grey.withValues(alpha: 0.6),
                            Colors.grey.withValues(alpha: 0.4),
                          ],
                  ),
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                            spreadRadius: -3,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.6),
                    width: 2,
                  ),
                )
              : BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.6),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: widget.size * 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
