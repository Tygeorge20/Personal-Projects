import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({Key? key}) : super(key: key);

  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  late List<List<String>> _board;
  late String _currentPlayer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _currentPlayer = 'X';
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  void _handleTap(int row, int col) {
    if (_board[row][col] != '') return;

    setState(() {
      _board[row][col] = _currentPlayer;
      if (_checkWinner(row, col)) {
        _showWinnerDialog(_currentPlayer);
      } else if (_isBoardFull()) {
        _showDrawDialog();
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (_board[row].every((cell) => cell == _currentPlayer)) return true;
    // Check column
    if (_board.every((r) => r[col] == _currentPlayer)) return true;
    // Check diagonal
    if (row == col && _board.every((r) => r[_board.indexOf(r)] == _currentPlayer)) return true;
    // Check anti-diagonal
    if (row + col == 2 && _board.every((r) => r[2 - _board.indexOf(r)] == _currentPlayer)) return true;

    return false;
  }

  bool _isBoardFull() {
    return _board.every((row) => row.every((cell) => cell != ''));
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('$winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('It\'s a draw!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () => _handleTap(row, col),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: _buildBoard(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGame,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
