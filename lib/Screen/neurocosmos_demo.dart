import 'package:flutter/material.dart';
import '../theme/neurocosmos_theme.dart';
import '../widgets/neurocosmos_panel.dart';
import '../widgets/neural_network_animation.dart';
import '../widgets/neurocosmos_button.dart';

class NeuroCosmosDemoScreen extends StatelessWidget {
  const NeuroCosmosDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeuroCosmosTheme.cosmosGradient,
        ),
        child: Stack(
          children: [
            // Neural network background animation
            const Positioned.fill(
              child: NeuralNetworkAnimation(
                isActive: true,
              ),
            ),
            // Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'NEUROCOSMOS',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: NeuroCosmosTheme.electricTurquoise,
                          shadows: [
                            Shadow(
                              color: NeuroCosmosTheme.electricTurquoise.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              color: NeuroCosmosTheme.neonPink.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Panel with content
                      NeuroCosmosPanel(
                        width: 350,
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Text(
                              'Welcome to the Future',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: NeuroCosmosTheme.electricTurquoise.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Experience the neural network interface with glassmorphism panels, glowing connections, and 3D interactive elements.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeuroCosmosButton(
                            text: 'START',
                            onPressed: () {},
                            accentColor: NeuroCosmosTheme.electricTurquoise,
                            width: 140,
                          ),
                          const SizedBox(width: 20),
                          NeuroCosmosButton(
                            text: 'EXPLORE',
                            onPressed: () {},
                            accentColor: NeuroCosmosTheme.neonPink,
                            width: 140,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Icon buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeuroCosmosIconButton(
                            icon: Icons.home,
                            onPressed: () {},
                            accentColor: NeuroCosmosTheme.electricTurquoise,
                          ),
                          const SizedBox(width: 16),
                          NeuroCosmosIconButton(
                            icon: Icons.settings,
                            onPressed: () {},
                            accentColor: NeuroCosmosTheme.neonPink,
                          ),
                          const SizedBox(width: 16),
                          NeuroCosmosIconButton(
                            icon: Icons.person,
                            onPressed: () {},
                            accentColor: NeuroCosmosTheme.brightOrange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Smaller panels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NeuroCosmosPanel(
                            width: 150,
                            height: 120,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.psychology,
                                  color: NeuroCosmosTheme.electricTurquoise,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Neural',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          NeuroCosmosPanel(
                            width: 150,
                            height: 120,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bolt,
                                  color: NeuroCosmosTheme.neonPink,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Energy',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
}
