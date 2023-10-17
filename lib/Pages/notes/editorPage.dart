import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';

import 'db/dbNotes.dart';
import 'model/note.dart';
import 'notesController.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({this.note, super.key});
  final Note? note;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

QuillController _controller = QuillController.basic();
final _formKey = GlobalKey<FormState>();
late int number;
late String title;
late String content;

class _EditorPageState extends State<EditorPage> {
  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (!_controller.document.isEmpty()) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: const Text("Заметка успешно сохранена"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  addNote();
                                  final NotesController controller =
                                      Get.put(NotesController());
                                  controller.refreshNotes();
                                  Get.back();
                                  Get.back();
                                },
                                child: const Text("ОК"),
                              )
                            ],
                          ));
                }
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  QuillToolbar.basic(
                    controller: _controller,
                    multiRowsDisplay: false,
                    showAlignmentButtons: true,
                  ),
                  Expanded(
                    child: Container(
                      child: QuillEditor.basic(
                        controller: _controller,
                        readOnly: false,
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

  Future addNote() async {
    var json = jsonEncode(_controller.document.toDelta().toJson());
    final note = Note(
      title: "",
      content: json,
      date_created: DateTime.now(),
      note_color: Colors.white.value,
      number: 0,
    );
    await DBNotes.instance.create(note);
    _controller.clear();
  }
}
