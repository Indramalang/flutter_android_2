import 'package:flutter/material.dart';

class ListCheckbox extends StatefulWidget {
  const ListCheckbox({super.key, required this.title});
  final String title;

  @override
  State<ListCheckbox> createState() => _ListCheckboxState();
}

class _ListCheckboxState extends State<ListCheckbox> {
  final Map<int, String> data = {
    1: 'Belajar Flutter',
    2: 'Latihan Coding',
    3: 'Mengerjakan Proyek'
  };
  final Map<int, bool> _isChecked = {};

  @override
  void initState() {
    super.initState();
    data.forEach((key, value) {
      _isChecked[key] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Todo'),
      ),
      body: data.isEmpty
          ? Center(
              child: Text(
                'Silahkan untuk membuat todo list',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                int key = data.keys.elementAt(index);
                String nama = data[key]!;
                return ListTile(
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      activeColor: Colors.purple,
                      checkColor: Colors.white,
                      value: _isChecked[key],
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked[key] = value!;
                        });
                      },
                    ),
                  ),
                  title: Text(nama, style: TextStyle(fontSize: 18.0)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            data.clear();
            _isChecked.clear();
          });
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
