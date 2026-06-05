import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/neurocosmos_theme.dart';

class NeuralNetworkAnimation extends StatefulWidget {
  final double? width;
  final double? height;
  final bool isActive;

  const NeuralNetworkAnimation({
    super.key,
    this.width,
    this.height,
    this.isActive = true,
  });

  @override
  State<NeuralNetworkAnimation> createState() => _NeuralNetworkAnimationState();
}

class _NeuralNetworkAnimationState extends State<NeuralNetworkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Neuron> _neurons = [];
  final List<Synapse> _synapses = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _initializeNetwork();
  }

  void _initializeNetwork() {
    final neuronCount = 15;
    for (int i = 0; i < neuronCount; i++) {
      _neurons.add(Neuron(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        phase: _random.nextDouble() * 2 * math.pi,
      ));
    }

    // Create connections between nearby neurons
    for (int i = 0; i < _neurons.length; i++) {
      for (int j = i + 1; j < _neurons.length; j++) {
        final distance = math.sqrt(
          math.pow(_neurons[i].x - _neurons[j].x, 2) +
              math.pow(_neurons[i].y - _neurons[j].y, 2),
        );
        if (distance < 0.4) {
          _synapses.add(Synapse(
            from: _neurons[i],
            to: _neurons[j],
            phase: _random.nextDouble() * 2 * math.pi,
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: NeuralNetworkPainter(
              neurons: _neurons,
              synapses: _synapses,
              animationValue: _controller.value,
              isActive: widget.isActive,
            ),
          );
        },
      ),
    );
  }
}

class Neuron {
  double x;
  double y;
  double phase;

  Neuron({
    required this.x,
    required this.y,
    required this.phase,
  });
}

class Synapse {
  final Neuron from;
  final Neuron to;
  double phase;

  Synapse({
    required this.from,
    required this.to,
    required this.phase,
  });
}

class NeuralNetworkPainter extends CustomPainter {
  final List<Neuron> neurons;
  final List<Synapse> synapses;
  final double animationValue;
  final bool isActive;

  NeuralNetworkPainter({
    required this.neurons,
    required this.synapses,
    required this.animationValue,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw synapses (connections)
    for (final synapse in synapses) {
      final pulse = (math.sin(animationValue * 2 * math.pi + synapse.phase) + 1) / 2;
      final opacity = isActive ? 0.1 + pulse * 0.3 : 0.05;

      final paint = Paint()
        ..color = NeuroCosmosTheme.electricTurquoise.withValues(alpha: opacity)
        ..strokeWidth = 1.5 + pulse
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(synapse.from.x * size.width, synapse.from.y * size.height),
        Offset(synapse.to.x * size.width, synapse.to.y * size.height),
        paint,
      );

      // Draw moving signal along the synapse
      if (isActive) {
        final signalPosition = (animationValue + synapse.phase) % 1;
        final signalX = synapse.from.x + (synapse.to.x - synapse.from.x) * signalPosition;
        final signalY = synapse.from.y + (synapse.to.y - synapse.from.y) * signalPosition;

        canvas.drawCircle(
          Offset(signalX * size.width, signalY * size.height),
          3,
          Paint()
            ..color = NeuroCosmosTheme.neonPink.withValues(alpha: 0.8)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // Draw neurons (nodes)
    for (final neuron in neurons) {
      final pulse = (math.sin(animationValue * 2 * math.pi + neuron.phase) + 1) / 2;
      final double radius = isActive ? 4.0 + pulse * 3.0 : 3.0;
      final opacity = isActive ? 0.6 + pulse * 0.4 : 0.3;

      // Outer glow
      canvas.drawCircle(
        Offset(neuron.x * size.width, neuron.y * size.height),
        radius * 2,
        Paint()
          ..color = NeuroCosmosTheme.electricTurquoise.withValues(alpha: opacity * 0.3)
          ..style = PaintingStyle.fill,
      );

      // Inner circle
      canvas.drawCircle(
        Offset(neuron.x * size.width, neuron.y * size.height),
        radius,
        Paint()
          ..color = NeuroCosmosTheme.electricTurquoise.withValues(alpha: opacity)
          ..style = PaintingStyle.fill,
      );

      // Core
      canvas.drawCircle(
        Offset(neuron.x * size.width, neuron.y * size.height),
        radius * 0.5,
        Paint()
          ..color = Colors.white.withValues(alpha: opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
