import 'package:flutter/material.dart';
import 'package:noteapprelem/src/noteFeature/controller/noteProvider.dart';
import 'package:noteapprelem/src/noteFeature/model/note_model.dart';
import 'package:noteapprelem/src/noteFeature/view/note_list.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import 'src/app.dart';
import 'src/settings/controller/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final app = App(AppConfiguration('application-0-vxwyf'));
  final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
  final realm = Realm(Configuration.flexibleSync(user, [NoteModel.schema]));
  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(realm.all<NoteModel>());
  });
  final allItems = realm.all<NoteModel>();

  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsController),
        ChangeNotifierProvider(create: (context) => NoteListProvider(allItems)),
      ],
      child: MyApp(),
    ),
  );
}
