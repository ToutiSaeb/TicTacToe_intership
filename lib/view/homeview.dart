import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/controller/gamecontroller.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  final GameController controller = Get.put(GameController());
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Obx(() {
            bool isGameOver = controller.winner.value != '' || controller.isDraw.value;

            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    Text(
                      'Current Player: ${controller.currentPlayer.value}',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Stack(
                        children: [
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (!isGameOver) {
                                    controller.makeMove(index);
                                    if (controller.winner.value != '' || controller.isDraw.value) {
                                      _animationController.forward();
                                    }
                                  }
                                },
                                child: Obx(() => Container(
                                      decoration: BoxDecoration(
                                        color: _getCellColor(index),
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          controller.board[index],
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: controller.board[index] == 'X' ? Colors.yellow.shade800 : Colors.pink.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )),
                              );
                            },
                          ),
                          if (isGameOver)
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            );
          }),
          Obx(() {
            if (controller.winner.value != '' || controller.isDraw.value) {
              return Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: Offset(0, 6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.winner.value != ''
                              ? 'Winner: ${controller.winner.value}'
                              : 'It\'s a Draw!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black38,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.resetGame();
                            _animationController.reset();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor:Colors.purpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            elevation: 8,
                          ),
                          child: Text('Reset Game', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Color _getCellColor(int index) {
    if (controller.board[index] == 'X') {
      return Colors.yellow.shade200;
    } else if (controller.board[index] == 'O') {
      return Colors.pink.shade200;
    } else {
      return Colors.white;
    }
  }
}
