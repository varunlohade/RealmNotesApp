// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class NoteModel extends _NoteModel
    with RealmEntity, RealmObjectBase, RealmObject {
  NoteModel(
    ObjectId id,
    int no,
    String noteTitle,
    String noteSubtitle,
    String notes,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'no', no);
    RealmObjectBase.set(this, 'noteTitle', noteTitle);
    RealmObjectBase.set(this, 'noteSubtitle', noteSubtitle);
    RealmObjectBase.set(this, 'notes', notes);
  }

  NoteModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int get no => RealmObjectBase.get<int>(this, 'no') as int;
  @override
  set no(int value) => RealmObjectBase.set(this, 'no', value);

  @override
  String get noteTitle =>
      RealmObjectBase.get<String>(this, 'noteTitle') as String;
  @override
  set noteTitle(String value) => RealmObjectBase.set(this, 'noteTitle', value);

  @override
  String get noteSubtitle =>
      RealmObjectBase.get<String>(this, 'noteSubtitle') as String;
  @override
  set noteSubtitle(String value) =>
      RealmObjectBase.set(this, 'noteSubtitle', value);

  @override
  String get notes => RealmObjectBase.get<String>(this, 'notes') as String;
  @override
  set notes(String value) => RealmObjectBase.set(this, 'notes', value);

  @override
  Stream<RealmObjectChanges<NoteModel>> get changes =>
      RealmObjectBase.getChanges<NoteModel>(this);

  @override
  NoteModel freeze() => RealmObjectBase.freezeObject<NoteModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(NoteModel._);
    return const SchemaObject(ObjectType.realmObject, NoteModel, 'NoteModel', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('no', RealmPropertyType.int),
      SchemaProperty('noteTitle', RealmPropertyType.string),
      SchemaProperty('noteSubtitle', RealmPropertyType.string),
      SchemaProperty('notes', RealmPropertyType.string),
    ]);
  }
}
