import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noteapprelem/src/noteFeature/model/note_model.dart';
import 'package:realm/realm.dart';

///Note list provider to add list
class NoteListProvider with ChangeNotifier {
  final RealmResults<NoteModel> items;
  final Realm _realm;
  late StreamSubscription _subscription;

  NoteListProvider(this.items) : _realm = items.realm {
    _subscription = items.changes.listen((changes) {
      print("changes deteced");
      _realm.refresh();
      notifyListeners();

      
    });
  }

  Realm get realm => _realm;

  void addNewItem(String title, String subtitle, String notes) {
    _realm.write(() {
      _realm.add(NoteModel(
          ObjectId(), 1 + (items.lastOrNull?.no ?? 0), title, subtitle, notes));

      notifyListeners(); // Notify the listeners about the change.
    });
  }

  @override
  void dispose() {
    // Important: Always cancel the subscription when it's no longer used to free up resources
    _subscription.cancel();
    super.dispose();
  }
}

///Note  provider to delete and update list

class NoteProvider with ChangeNotifier {
  final NoteModel item;
  final Realm _realm;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  NoteProvider(this.item) : _realm = item.realm {
    titleController.text = item.noteTitle;
    subtitleController.text = item.noteSubtitle;
    descriptionController.text = item.notes;
  }

  void delete(NoteListProvider noteListProvider) {
    if (!item.isValid) {
      return;
    }
    _realm.write(() {
      _realm.delete(item);
      notifyListeners();
      // Notify the NoteListProvider to refresh the list.
      noteListProvider.notifyListeners();
    });
  }

  void updateTitle(String notes) {
    _realm.write(() {
      item.notes = notes;

      notifyListeners();
    });
  }

  void disposeControllers() {
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
