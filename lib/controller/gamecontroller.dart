import 'package:get/get.dart';

class GameController extends GetxController {
  var board = List.filled(9, '', growable: false).obs;
  var currentPlayer = 'X'.obs;
  var winner = ''.obs;
  var isDraw = false.obs;

  void makeMove(int index) {
    if (board[index] == '' && winner.value == '') {
      board[index] = currentPlayer.value;
      if (checkWinner()) {
        winner.value = currentPlayer.value;
      } else if (board.every((element) => element != '')) {
        isDraw.value = true;
      } else {
        currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
      }
    }
  }

  bool checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] == currentPlayer.value &&
          board[combination[1]] == currentPlayer.value &&
          board[combination[2]] == currentPlayer.value) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    board.value = List.filled(9, '', growable: false);
    currentPlayer.value = 'X';
    winner.value = '';
    isDraw.value = false;
  }
}
