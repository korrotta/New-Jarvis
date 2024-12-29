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
    apiKey: 'AIzaSyBqdw6a69SUX9p5WUvFVjZJ3b28GifBFWQ',
    appId: '1:880284024996:web:214867ee3ccecb73312631',
    messagingSenderId: '880284024996',
    projectId: 'new-jarvis-51b90',
    authDomain: 'new-jarvis-51b90.firebaseapp.com',
    storageBucket: 'new-jarvis-51b90.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBlB1Q6AqoUbLGF_ne1r0xitT9lVHrAE2s',
    appId: '1:880284024996:android:309985461e69b232312631',
    messagingSenderId: '880284024996',
    projectId: 'new-jarvis-51b90',
    storageBucket: 'new-jarvis-51b90.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASWA2aEl_WyLIWqKfWfn-pU0Rn8pL6xLU',
    appId: '1:880284024996:ios:341e089a8e5dc0ca312631',
    messagingSenderId: '880284024996',
    projectId: 'new-jarvis-51b90',
    storageBucket: 'new-jarvis-51b90.firebasestorage.app',
    androidClientId: '880284024996-gkqfi56td77r6dopep1i10rfgmka36dh.apps.googleusercontent.com',
    iosClientId: '880284024996-npqqj8jqh8n5if8007j90sk966di51ar.apps.googleusercontent.com',
    iosBundleId: 'com.example.newjarvis',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASWA2aEl_WyLIWqKfWfn-pU0Rn8pL6xLU',
    appId: '1:880284024996:ios:341e089a8e5dc0ca312631',
    messagingSenderId: '880284024996',
    projectId: 'new-jarvis-51b90',
    storageBucket: 'new-jarvis-51b90.firebasestorage.app',
    androidClientId: '880284024996-gkqfi56td77r6dopep1i10rfgmka36dh.apps.googleusercontent.com',
    iosClientId: '880284024996-npqqj8jqh8n5if8007j90sk966di51ar.apps.googleusercontent.com',
    iosBundleId: 'com.example.newjarvis',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqdw6a69SUX9p5WUvFVjZJ3b28GifBFWQ',
    appId: '1:880284024996:web:674ebe295f8688d9312631',
    messagingSenderId: '880284024996',
    projectId: 'new-jarvis-51b90',
    authDomain: 'new-jarvis-51b90.firebaseapp.com',
    storageBucket: 'new-jarvis-51b90.firebasestorage.app',
  );

}