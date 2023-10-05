import 'package:realm/realm.dart';

/// A placeholder class that represents an entity or model.
part 'note_model.g.dart';

@RealmModel()
class _NoteModel {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late int no;
  late String noteTitle;
  late String noteSubtitle;
  late String notes;
}
