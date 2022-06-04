import 'package:flutter/material.dart';
import 'package:notes_dapp/Providers/notes.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var noteServices = Provider.of<NotesServices>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      body: ListView.builder(
          itemCount: noteServices.notes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(noteServices.notes[index].title),
              subtitle: Text(noteServices.notes[index].description),
              trailing: IconButton(
                  onPressed: () =>
                      noteServices.deleteNote(noteServices.notes[index].id),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("New Note"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(hintText: "Enter title"),
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(hintText: "Enter title"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Add"),
                      onPressed: () {
                        noteServices.addNote(
                            _titleController.text, _descriptionController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
