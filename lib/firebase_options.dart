// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAxNoQVb6gr36-awRpKeO3SNP21jEbo7cE',
    appId: '1:947097211718:web:0776905615ca2bec798b47',
    messagingSenderId: '947097211718',
    projectId: 'project24-d4cc2',
    authDomain: 'project24-d4cc2.firebaseapp.com',
    databaseURL: 'https://project24-d4cc2-default-rtdb.firebaseio.com',
    storageBucket: 'project24-d4cc2.appspot.com',
    measurementId: 'G-EZD71FTL9W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiqhYHujzsS_KDEnaUPm-Vv71d-CnapQo',
    appId: '1:947097211718:android:ef77902702254301798b47',
    messagingSenderId: '947097211718',
    projectId: 'project24-d4cc2',
    databaseURL: 'https://project24-d4cc2-default-rtdb.firebaseio.com',
    storageBucket: 'project24-d4cc2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQo3HyMZ_BhcarIr7jrNNkNYBvEpHlITo',
    appId: '1:947097211718:ios:ad4ac7721db74be0798b47',
    messagingSenderId: '947097211718',
    projectId: 'project24-d4cc2',
    databaseURL: 'https://project24-d4cc2-default-rtdb.firebaseio.com',
    storageBucket: 'project24-d4cc2.appspot.com',
    iosBundleId: 'com.example.project24',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQo3HyMZ_BhcarIr7jrNNkNYBvEpHlITo',
    appId: '1:947097211718:ios:ad4ac7721db74be0798b47',
    messagingSenderId: '947097211718',
    projectId: 'project24-d4cc2',
    databaseURL: 'https://project24-d4cc2-default-rtdb.firebaseio.com',
    storageBucket: 'project24-d4cc2.appspot.com',
    iosBundleId: 'com.example.project24',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxNoQVb6gr36-awRpKeO3SNP21jEbo7cE',
    appId: '1:947097211718:web:c8be6324d05b5888798b47',
    messagingSenderId: '947097211718',
    projectId: 'project24-d4cc2',
    authDomain: 'project24-d4cc2.firebaseapp.com',
    databaseURL: 'https://project24-d4cc2-default-rtdb.firebaseio.com',
    storageBucket: 'project24-d4cc2.appspot.com',
    measurementId: 'G-4TSVLHJP45',
  );
}
