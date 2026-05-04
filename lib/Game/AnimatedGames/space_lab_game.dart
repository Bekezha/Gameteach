import 'dart:math'; // Added for max()
import 'package:flutter/material.dart';

class SpaceLabGame extends StatefulWidget {
  const SpaceLabGame({Key? key}) : super(key: key);

  @override
  State<SpaceLabGame> createState() => _SpaceLabGameState();
}

class _SpaceLabGameState extends State<SpaceLabGame> with TickerProviderStateMixin {
  int _hydrogenCount = 0;
  bool _isWaterFormed = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  void _onAcceptHydrogen() {
    setState(() {
      _hydrogenCount++;
      if (_hydrogenCount >= 2) {
        _isWaterFormed = true;
        _particlesController.forward(from: 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Космическая лаборатория", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background Stars here (simplified)
            ...List.generate(30, (index) => _buildStar(index)),

            // Draggable Hydrogens
            if (!_isWaterFormed) ...[
              Positioned(
                top: 150,
                left: 50,
                child: _buildDraggableAtom("H", Colors.lightBlueAccent),
              ),
              Positioned(
                bottom: 150,
                right: 50,
                child: _buildDraggableAtom("H", Colors.lightBlueAccent),
              ),
            ],

            // Center Target (Oxygen or Water)
            Center(
              child: _isWaterFormed
                  ? _buildWaterMolecule()
                  : _buildOxygenTarget(),
            ),

            if (_isWaterFormed)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      setState(() {
                        _hydrogenCount = 0;
                        _isWaterFormed = false;
                      });
                    },
                    child: const Text("Повторить эксперимент", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(int index) {
    final rand = (index * 13) % 100;
    return Positioned(
      top: (index * 25.0) % MediaQuery.of(context).size.height,
      left: (rand * 15.0) % MediaQuery.of(context).size.width,
      child: Container(
        width: 2,
        height: 2,
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildDraggableAtom(String symbol, Color color) {
    final atomWidget = Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 5),
        ],
      ),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Draggable<String>(
      data: symbol,
      feedback: Transform.scale(
        scale: 1.2,
        child: atomWidget,
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: atomWidget,
      ),
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: atomWidget,
      ),
    );
  }

  Widget _buildOxygenTarget() {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isHovered ? 150 : 120,
          height: isHovered ? 150 : 120,
          decoration: BoxDecoration(
            color: isHovered ? Colors.redAccent.withOpacity(0.9) : Colors.red.withOpacity(0.7),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(isHovered ? 0.8 : 0.4),
                blurRadius: isHovered ? 30 : 15,
                spreadRadius: isHovered ? 15 : 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "O\n(H: $_hydrogenCount/2)",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
      onWillAccept: (data) => data == "H" && _hydrogenCount < 2,
      onAccept: (data) {
        _onAcceptHydrogen();
      },
    );
  }

  Widget _buildWaterMolecule() {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: AnimatedBuilder(
        animation: _particlesController,
        builder: (context, child) {
          final scale = 1.0 + (_particlesController.value * 0.2);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(max(0, 1 - _particlesController.value)),
                    blurRadius: 50 * _particlesController.value,
                    spreadRadius: 20 * _particlesController.value,
                  ),
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "H₂O\nВода!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
