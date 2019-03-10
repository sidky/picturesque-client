import 'package:firebase_core/firebase_core.dart';
import '../secret.dart';

class FirebasePicturesqueApp {
  static FirebasePicturesqueApp _instance;
  final FirebaseApp _app;

  FirebasePicturesqueApp._internal(this._app);

  static Future<FirebaseApp> instance() async {
    if (_instance == null) {
      var app = await FirebaseApp.configure(name: 'picturesque',
          options: const FirebaseOptions(
              googleAppID: googleAppId,
              apiKey: googleAPIKey,
              databaseURL: firebaseDatabaseURL));
      _instance = FirebasePicturesqueApp._internal(app);
    }
    return _instance._app;
  }
}