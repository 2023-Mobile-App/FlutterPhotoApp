// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDb3tlmwCDaCTisiRlXQxwyDcyZ6Dn4aYQ',
    appId: '1:932828636770:web:c8cce07bb9a9c86cf9133b',
    messagingSenderId: '932828636770',
    projectId: 'tutorial-samplea-application',
    authDomain: 'tutorial-samplea-application.firebaseapp.com',
    storageBucket: 'tutorial-samplea-application.appspot.com',
    measurementId: 'G-GZ7VNG3ESQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAK01_x70RAzc_W5V7O0lxaQIwFpWv8DA',
    appId: '1:932828636770:android:06903bb3a138328ef9133b',
    messagingSenderId: '932828636770',
    projectId: 'tutorial-samplea-application',
    storageBucket: 'tutorial-samplea-application.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDchlN4QFcOo5sORnEBGNbk29onZSEoRwk',
    appId: '1:932828636770:ios:a06a62440a1673c7f9133b',
    messagingSenderId: '932828636770',
    projectId: 'tutorial-samplea-application',
    storageBucket: 'tutorial-samplea-application.appspot.com',
    iosClientId: '932828636770-sgna1mee4tl173rs1k3hr272n15na9a7.apps.googleusercontent.com',
    iosBundleId: 'com.example.tutorialSampleaApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDchlN4QFcOo5sORnEBGNbk29onZSEoRwk',
    appId: '1:932828636770:ios:a06a62440a1673c7f9133b',
    messagingSenderId: '932828636770',
    projectId: 'tutorial-samplea-application',
    storageBucket: 'tutorial-samplea-application.appspot.com',
    iosClientId: '932828636770-sgna1mee4tl173rs1k3hr272n15na9a7.apps.googleusercontent.com',
    iosBundleId: 'com.example.tutorialSampleaApplication',
  );
}
