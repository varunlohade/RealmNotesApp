import 'package:flutter/material.dart';
import 'package:noteapprelem/src/noteFeature/controller/noteProvider.dart';
import 'package:noteapprelem/utils/search_feature/search.dart';
import 'package:provider/provider.dart';

import '../../settings/view/settings_view.dart';
import '../model/note_model.dart';

/// Widget to display note list
class NoteItemList extends StatefulWidget {
  const NoteItemList({
    super.key,
  });

  static const routeName = '/';

  @override
  State<NoteItemList> createState() => _NoteItemListState();
}

class _NoteItemListState extends State<NoteItemList> {
  TextEditingController titleController = TextEditingController();

  TextEditingController subtitleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteListProvider =
        Provider.of<NoteListProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes: Flexible sync"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotesSearch(noteListProvider.realm),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openSheetNotes(context, noteListProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<NoteListProvider>(
          builder: (context, noteListProvider, child) {
        return ListView.builder(
          itemCount: noteListProvider.items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = noteListProvider.items[index];
            if (!item.isValid) {
              return const SizedBox.shrink();
              // or some other placeholder widget.
            }
            return ChangeNotifierProvider<NoteProvider>(
              create: (context) => NoteProvider(item),
              child: NoteItemTile(
                item: item,
              ),
            );
          },
        );
      }),
    );
  }

  /// Bottomsheet to take input for notes 
  Future<dynamic> openSheetNotes(
      BuildContext context, NoteListProvider provider) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  BuildNoteInputField(
                    title: "Title for Notes",
                    hint: "Enter title for Notes",
                    controller: titleController,
                    description: "",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BuildNoteInputField(
                    title: "Subtitle for Notes",
                    hint: "Enter Subtitle for Notes",
                    controller: subtitleController,
                    description: "",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BuildNoteInputField(
                    title: "Notes",
                    hint: "Start Writing",
                    controller: descriptionController,
                    description: "",
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          Feedback.forTap(context);
                          provider.addNewItem(
                              titleController.text,
                              subtitleController.text,
                              descriptionController.text);

                          clearController();

                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 130,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(146, 133, 93, 228),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void clearController() {
    titleController.clear();
    subtitleController.clear();
    descriptionController.clear();
  }
}

/// Widget to build inputField for taking input for notes
// ignore: must_be_immutable
class BuildNoteInputField extends StatefulWidget {
  BuildNoteInputField(
      {super.key,
      required this.title,
      required this.hint,
      required this.description,
      required this.controller});

  final String title;
  final String hint;
  final String description;
  TextEditingController controller;

  @override
  State<BuildNoteInputField> createState() => _buildNoteInputFieldState();
}

// ignore: camel_case_types
class _buildNoteInputFieldState extends State<BuildNoteInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        if (widget.title != "Notes")
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: double.maxFinite,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: (widget.title != "Notes")
                  ? Border.all(color: const Color.fromARGB(187, 92, 91, 91))
                  : null),
          child: TextFormField(
            autofocus: true,
            controller: widget.controller,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: InputBorder.none,
                hintText: widget.title != "Notes" ? null : widget.description,
                hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300)),
          ),
        ),
      ],
    );
  }
}



/// Single note tile widget
class NoteItemTile extends StatelessWidget {
  const NoteItemTile({Key? key, required this.item}) : super(key: key);

  final NoteModel item;

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: true);
    final noteListProvider =
        Provider.of<NoteListProvider>(context, listen: true);

    final item = noteProvider.item;
    if (!item.isValid) {
      return const SizedBox
          .shrink(); // Render an empty widget if the item is not valid
    }
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        noteProvider.delete(noteListProvider);
      },
      child: ListTile(
        title: Text(
          item.noteTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color.fromARGB(105, 158, 158, 158),
          size: 16,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.noteSubtitle,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.maxFinite,
              height: 1,
              color: const Color.fromARGB(105, 158, 158, 158),
            )
          ],
        ),
        onTap: () {
          buildNoteSheet(context, noteProvider);
        },
      ),
    );
  }


/// Bottomsheet to show notes description
  Future<dynamic> buildNoteSheet(BuildContext context, NoteProvider bloc) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        bloc.item.noteTitle,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      const Text("Tap to type")
                    ],
                  ),
                  BuildNoteInputField(
                      title: "Notes",
                      hint: "Start Writing",
                      description: bloc.item.notes,
                      controller: bloc.descriptionController),
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Feedback.forTap(context);
                          bloc.updateTitle(bloc.descriptionController.text);

                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 130,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(146, 133, 93, 228),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
