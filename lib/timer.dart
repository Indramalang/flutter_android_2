import 'dart:async';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _isRunning = false;
  int _totalSecondsAtStart = 60; // Tambahkan ini

  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _secondController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _totalSecondsAtStart = _remainingSeconds; // Inisialisasi saat widget dibuat
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) return;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          // Tambahkan logika untuk memainkan suara di sini
        }
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _getTotalSecondsFromInput();
      _totalSecondsAtStart = _remainingSeconds; // Update saat reset
      _isRunning = false;
    });
  }

  void _setTimeFromInput() {
    setState(() {
      _remainingSeconds = _getTotalSecondsFromInput();
      _totalSecondsAtStart = _remainingSeconds; // Update saat input berubah
    });
  }

  int _getTotalSecondsFromInput() {
    final hours = int.tryParse(_hourController.text) ?? 0;
    final minutes = int.tryParse(_minuteController.text) ?? 0;
    final seconds = int.tryParse(_secondController.text) ?? 0;
    return hours * 3600 + minutes * 60 + seconds;
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _formatTime(_remainingSeconds),
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _totalSecondsAtStart > 0
                    ? _remainingSeconds / _totalSecondsAtStart
                    : 0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeInputField(_hourController, 'Jam', '00'),
                SizedBox(width: 10),
                _buildTimeInputField(_minuteController, 'Menit', '00'),
                SizedBox(width: 10),
                _buildTimeInputField(_secondController, 'Detik', '00'),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow,
                      size: 30),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(25),
                    backgroundColor: _isRunning ? Colors.orange : Colors.blue,
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Icon(Icons.replay, size: 30),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(25),
                    backgroundColor: Color.fromARGB(255, 199, 64, 64),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputField(
      TextEditingController controller, String label, String hint) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          _setTimeFromInput();
        },
      ),
    );
  }
}
