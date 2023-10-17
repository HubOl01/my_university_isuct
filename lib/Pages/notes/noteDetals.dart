import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_university_isuct/Pages/notes/db/dbNotes.dart';
import 'package:my_university_isuct/Pages/notes/noteDetalsController.dart';
import 'package:my_university_isuct/Pages/notes/notesController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class NoteDetals extends StatefulWidget {
  final title;
  final content;
  final DateTime date;
  final notelist;
  const NoteDetals(
      {required this.title,
      required this.content,
      required this.date,
      required this.notelist,
      super.key});

  @override
  State<NoteDetals> createState() => _NoteDetalsState();
}

QuillController _controller = QuillController.basic();
bool isEdit = false;

class _NoteDetalsState extends State<NoteDetals> {
  @override
  void initState() {
    super.initState();
    _controller = QuillController(
      document: Document.fromJson(jsonDecode(widget.content)),
      selection: TextSelection.collapsed(offset: 0),
    );
  }
  @override
  Widget build(BuildContext context) {
    print('test ${widget.notelist.number} ${widget.notelist.note_color}');
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final converter = QuillDeltaToHtmlConverter(
                  List.castFrom(Document.fromJson(jsonDecode(widget.content))
                      .toDelta()
                      .toJson()),
                );

                var html = converter.convert();
                html = '<div style="max-width: 800px;">\n$html\n</div>';
                final directory =
                    await getApplicationDocumentsDirectory(); // Используйте getApplicationDocumentsDirectory() для внутреннего хранилища
                final filePath = '${directory.path}/document${widget.notelist.id}.html';

                final File file = File(filePath);
                await file.writeAsString(html);

                print('HTML файл сохранен в пути: $filePath');
                await Share.shareXFiles([XFile(filePath)]);
              },
              icon: Icon(Icons.share)),
          IconButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                  _controller = QuillController(
                    document: Document.fromJson(jsonDecode(widget.content)),
                    selection: TextSelection.collapsed(offset: 0),
                  );
                });
              },
              icon: Icon(!isEdit ? Icons.edit : Icons.close)),
          if (isEdit)
            IconButton(
                onPressed: () {
                  updateNote();
                  final NoteDetalsController controller =
                      Get.put(NoteDetalsController());
                  controller.refreshNote(widget.notelist.id);
                  final NotesController notesController =
                      Get.put(NotesController());
                  notesController.refreshNotes();
                  setState(() {
                    isEdit = false;
                  });
                },
                icon: Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              DateFormat('HH:mm dd.MM.yyyy').format(widget.date),
              style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: 4,
            ),
            isEdit
                ? QuillToolbar.basic(
                    controller: _controller,
                    multiRowsDisplay: false,
                    showAlignmentButtons: true,
                  )
                : SizedBox(),
            isEdit ? SizedBox(height: 8) : SizedBox(),
            QuillEditor(
              controller: _controller,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: FocusNode(),
              autoFocus: true,
              readOnly: !isEdit,
              expands: false,
              showCursor: isEdit,
              padding: EdgeInsets.zero,
            )
          ]),
        ),
      ),
    );
  }

  Future updateNote() async {
    var json = jsonEncode(_controller.document.toDelta().toJson());
    final note = widget.notelist.copy(
      title: '',
      content: json,
      note_color: Colors.white.value,
      number: 0,
    );
    await DBNotes.instance.update(note);
  }
}
