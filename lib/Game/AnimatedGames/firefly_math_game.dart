import 'package:flutter/material.dart';

class FireflyMathGame extends StatefulWidget {
  const FireflyMathGame({Key? key}) : super(key: key);

  @override
  State<FireflyMathGame> createState() => _FireflyMathGameState();
}

class _FireflyMathGameState extends State<FireflyMathGame> with TickerProviderStateMixin {
  bool _isSolved = false;
  
  late AnimationController _fireflyController;
  late Animation<Offset> _fireflyAnimation;

  final int _targetAnswer = 3;

  @override
  void initState() {
    super.initState();
    _fireflyController = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 3),
    );

    // Moves firefly diagonally towards top right flower
    _fireflyAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0.8),
      end: const Offset(0.8, 0.1),
    ).animate(CurvedAnimation(
      parent: _fireflyController,
      curve: Curves.easeInOutQuad,
    ));
  }

  @override
  void dispose() {
    _fireflyController.dispose();
    super.dispose();
  }

  void _onAcceptAnswer(int number) {
    if (number == _targetAnswer) {
      setState(() {
        _isSolved = true;
      });
      _fireflyController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Магический лес", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
         decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF1E3C2F), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Flower (Target)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: const Icon(Icons.local_florist, color: Colors.pinkAccent, size: 80),
            ),
            
            // Firefly
            AnimatedBuilder(
              animation: _fireflyAnimation,
              builder: (context, child) {
                return Positioned(
                  left: MediaQuery.of(context).size.width * _fireflyAnimation.value.dx,
                  top: MediaQuery.of(context).size.height * _fireflyAnimation.value.dy,
                   child: _buildFirefly(),
                );
              },
            ),

            // Equation Area at the bottom
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  _buildEquationSlot(),
                  const SizedBox(height: 30),
                  if (!_isSolved)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDraggableNumber(2),
                        _buildDraggableNumber(5),
                        _buildDraggableNumber(3),
                        _buildDraggableNumber(8),
                      ],
                    ),
                  if (_isSolved)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.amber,
                         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                         setState(() {
                           _isSolved = false;
                         });
                         _fireflyController.reset();
                      },
                      child: const Text("Следующая загадка", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFirefly() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellowAccent,
        boxShadow: [
           BoxShadow(
             color: Colors.amberAccent.withOpacity(0.8),
             blurRadius: 20,
             spreadRadius: 10,
           ),
        ],
      ),
      child: const Icon(Icons.bug_report, size: 20, color: Colors.orange),
    );
  }

  Widget _buildEquationSlot() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.lightGreenAccent, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("5 + ", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
          DragTarget<int>(
            builder: (context, candidateData, rejectedData) {
              final isHovered = candidateData.isNotEmpty;
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _isSolved 
                    ? Colors.greenAccent 
                    : (isHovered ? Colors.lightGreenAccent.withOpacity(0.5) : Colors.white24),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isHovered ? Colors.yellow : Colors.transparent, width: 2),
                ),
                child: Center(
                  child: Text(
                    _isSolved ? _targetAnswer.toString() : "?",
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            onWillAccept: (data) => true,
            onAccept: (data) {
               _onAcceptAnswer(data);
            },
          ),
          const Text(" = 8", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDraggableNumber(int number) {
    final block = Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 5, offset: Offset(2, 2))],
      ),
      child: Center(
        child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
      ),
    );

    return Draggable<int>(
      data: number,
      feedback: Transform.scale(scale: 1.2, child: block),
      childWhenDragging: Opacity(opacity: 0.3, child: block),
      child: block,
    );
  }
}
