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
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box('todoBox');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void addTodoItem(String item) {
    todoBox.add({'task': item, 'isChecked': false});
    setState(() {});
  }

  void toggleCheckbox(int index, bool? value) {
    var task = todoBox.getAt(index);
    todoBox.putAt(index, {'task': task['task'], 'isChecked': value});
    setState(() {});
  }

  void deleteAllTasks() {
    todoBox.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 2, // Tambahkan sedikit bayangan
      ),
      body: todoBox.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.playlist_add_check,
                      size: 80, color: Colors.grey), // Tambah ikon
                  SizedBox(height: 10),
                  Text(
                    'Yuk, mulai buat daftar tugasmu!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: todoBox.length,
              itemBuilder: (context, index) {
                var task = todoBox.getAt(index);
                return Card(
                  // Bungkus dengan Card
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        activeColor: Colors.purple,
                        checkColor: Colors.white,
                        value: task['isChecked'],
                        onChanged: (value) => toggleCheckbox(index, value),
                      ),
                    ),
                    title: Text(
                      task['task'],
                      style: TextStyle(
                        fontSize: 18.0,
                        decoration: task['isChecked']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            // Tambahkan konfirmasi
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Konfirmasi Hapus'),
                content: Text('Yakin ingin menghapus semua tugas?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Batal'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Hapus', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      deleteAllTasks();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.redAccent, // Warna yang lebih 'berbahaya'
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Tambah Todo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                String newTask = _textController.text.trim();
                if (newTask.isNotEmpty) {
                  addTodoItem(newTask);
                  _textController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    // Feedback visual
                    SnackBar(content: Text('$newTask ditambahkan!')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
