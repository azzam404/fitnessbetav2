// File generated by FlutterFire CLI.
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
    apiKey: 'AIzaSyDNB14t0bgc9SaAogbdq2Mvd8sV0Ndfd2U',
    appId: '1:954428036526:web:e297edaecafa4fd69a243f',
    messagingSenderId: '954428036526',
    projectId: 'fitnessbetav2',
    authDomain: 'fitnessbetav2.firebaseapp.com',
    storageBucket: 'fitnessbetav2.firebasestorage.app',
    measurementId: 'G-9T99FD4J45',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBasuPj14iUEeX4EGKMR6C2o2HF8hQ4KKc',
    appId: '1:954428036526:android:6ee5eb64380791aa9a243f',
    messagingSenderId: '954428036526',
    projectId: 'fitnessbetav2',
    storageBucket: 'fitnessbetav2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuv3Juq2EvPvQ1s1F3goBJ43qcrU24yBg',
    appId: '1:954428036526:ios:a146a047207c657a9a243f',
    messagingSenderId: '954428036526',
    projectId: 'fitnessbetav2',
    storageBucket: 'fitnessbetav2.firebasestorage.app',
    iosBundleId: 'com.example.fitnessbetav2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuv3Juq2EvPvQ1s1F3goBJ43qcrU24yBg',
    appId: '1:954428036526:ios:a146a047207c657a9a243f',
    messagingSenderId: '954428036526',
    projectId: 'fitnessbetav2',
    storageBucket: 'fitnessbetav2.firebasestorage.app',
    iosBundleId: 'com.example.fitnessbetav2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDNB14t0bgc9SaAogbdq2Mvd8sV0Ndfd2U',
    appId: '1:954428036526:web:54037e7ee1c980559a243f',
    messagingSenderId: '954428036526',
    projectId: 'fitnessbetav2',
    authDomain: 'fitnessbetav2.firebaseapp.com',
    storageBucket: 'fitnessbetav2.firebasestorage.app',
    measurementId: 'G-MML12H1MZJ',
  );
}