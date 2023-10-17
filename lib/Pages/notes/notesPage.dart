import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_university_isuct/Pages/notes/noteDetals.dart';

import 'editorPage.dart';
import 'notesController.dart';

class NotesPage extends GetView<NotesController> {
  const NotesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.notes.isEmpty
                  ? const Center(
                      child: Text("Нет данных"),
                    )
                  : MasonryGridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      primary: false,

                      // padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 2,
                      itemCount: controller.notes.length,
                      mainAxisSpacing: 2,
                      itemBuilder: (context, index) {
                        double getMinHeight(int index) {
                          switch (index % 4) {
                            case 0:
                              return 100;
                            case 1:
                              return 150;
                            case 2:
                              return 150;
                            case 3:
                              return 100;
                            default:
                              return 100;
                          }
                        }

                        final _lightColors = [
                          Colors.amber.shade300,
                          Colors.lightGreen.shade300,
                          Colors.lightBlue.shade100,
                          Colors.orange.shade200,
                          Colors.pinkAccent.shade100,
                          Colors.tealAccent.shade100
                        ];
                        final _darkColors = [
                          Colors.amber,
                          Colors.green,
                          Colors.lightBlue,
                          Colors.orange,
                          Colors.pinkAccent,
                          Colors.teal
                        ];
                        final color = context.isDarkMode
                            ? _darkColors[index % _darkColors.length]
                            : _lightColors[index % _lightColors.length];
                        final time = DateFormat('HH:mm dd.MM.yyyy')
                            .format(controller.notes[index].date_created);
                        final minHeight = getMinHeight(index);
                        return Card(
                            color: color,
                            child: InkWell(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (builder) => AlertDialog(
                                          title: Text("Подтверждение"),
                                          content: Text(
                                              "Вы хотите удалить заметку?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("Нет")),
                                            TextButton(
                                                onPressed: () {
                                                  controller.deleteNote(
                                                      controller
                                                          .notes[index].id!);
                                                  Get.back();
                                                },
                                                child: Text("Да"))
                                          ],
                                        ));
                              },
                              onTap: () {
                                Get.to(NoteDetals(
                                  title: controller.notes[index].title,
                                  content: controller.notes[index].content,
                                  date: controller.notes[index].date_created,
                                  notelist: controller.notes[index],
                                ));
                              },
                              child: Container(
                                constraints:
                                    BoxConstraints(minHeight: minHeight),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      time,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    SizedBox(height: 4),
                                    QuillEditor(
                                      maxHeight: 400,
                                      controller: controller.contentText(
                                          controller.notes[index].content),
                                      scrollController: ScrollController(),
                                      scrollable: true,
                                      focusNode: FocusNode(),
                                      autoFocus: false,
                                      enableInteractiveSelection: false,
                                      readOnly: true,
                                      expands: false,
                                      showCursor: false,
                                      padding: EdgeInsets.zero,
                                    )
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppMetrica.reportEvent('Добавление заметок');
              Get.to(const EditorPage());
            },
            child: const Icon(Icons.create),
          ),
        ));
  }
}

final NotesController controller = Get.put(NotesController());
