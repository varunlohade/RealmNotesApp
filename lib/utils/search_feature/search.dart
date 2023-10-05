import 'package:flutter/material.dart';
import 'package:noteapprelem/src/noteFeature/model/note_model.dart';
import 'package:realm/realm.dart';

class NotesSearch extends SearchDelegate {
  final Realm realm;

  NotesSearch(this.realm);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredNotes = realm
        .all<NoteModel>()
        .where((note) =>
            note.noteTitle.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final item = filteredNotes[index];
        return ListTile(
          title: Text(item.noteTitle),
          subtitle: Text(item.noteSubtitle),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
