import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import 'db/dbNotes.dart';
import 'model/note.dart';

class NotesController extends GetxController {
  var notes = <Note>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    refreshNotes();
  }

  @override
  void dispose() {
    DBNotes.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    isLoading.value = true;
    notes.value = await DBNotes.instance.readAllNotes();
    print("Запущен проект");
    isLoading.value = false;
  }

  Future deleteNote(int id) async {
    await DBNotes.instance.delete(id);
    refreshNotes();
  }

  QuillController contentText(String content) {
    QuillController _controller = QuillController.basic();
    _controller = QuillController(
      document: Document.fromJson(jsonDecode(content)),
      selection: TextSelection.collapsed(offset: 0),
    );
    return _controller;
  }
}
