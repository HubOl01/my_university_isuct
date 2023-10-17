import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:my_university_isuct/Pages/notes/db/dbNotes.dart';

import 'model/note.dart';

class NoteDetalsController extends GetxController {
  var notes = <Note>[].obs;
  var note;
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

  Future refreshNote(int id) async {
    isLoading.value = true;
    note.value = await DBNotes.instance.readNote(id);
    print("Запущен проект");
    isLoading.value = false;
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
