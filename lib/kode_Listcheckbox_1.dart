import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListCheckbox extends StatefulWidget {
  const ListCheckbox({super.key, required this.title});
  final String title;

  @override
  State<ListCheckbox> createState() => _ListCheckboxState();
}

class _ListCheckboxState extends State<ListCheckbox> {
  late Box todoBox;
  final TextEditingController _textController =
      TextEditingController(); // Tambahkan controller

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box('todoBox'); // Inisialisasi Hive box
  }

  @override
  void dispose() {
    _textController.dispose(); // Hapus controller saat widget dihancurkan
    super.dispose();
  }

  void addTodoItem(String item) {
    todoBox.add({'task': item, 'isChecked': false}); // Menambahkan item baru
    setState(() {}); // Memperbarui tampilan
  }

  void toggleCheckbox(int index, bool? value) {
    var task = todoBox.getAt(index);
    todoBox.putAt(index,
        {'task': task['task'], 'isChecked': value}); // Memperbarui checkbox
    setState(() {}); // Memperbarui tampilan
  }

  void deleteAllTasks() {
    todoBox.clear(); // Menghapus semua item
    setState(() {}); // Memperbarui tampilan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: todoBox.isEmpty
          ? Center(
              child: Text(
                'Silahkan untuk membuat todo list',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: todoBox.length,
              itemBuilder: (context, index) {
                var task = todoBox.getAt(index);
                return ListTile(
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      activeColor: Colors.purple,
                      checkColor: Colors.white,
                      value: task['isChecked'],
                      onChanged: (value) => toggleCheckbox(index, value),
                    ),
                  ),
                  title: Text(task['task'], style: TextStyle(fontSize: 18.0)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteAllTasks(),
        child: Icon(Icons.delete),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller:
                    _textController, // Controller untuk mengontrol input
                decoration: InputDecoration(
                  hintText: 'Tambah Todo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                String newTask =
                    _textController.text.trim(); // Ambil teks input
                if (newTask.isNotEmpty) {
                  addTodoItem(newTask); // Tambahkan ke daftar
                  _textController.clear(); // Hapus teks dari TextField
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
