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
    apiKey: 'AIzaSyD9fptM5AN6QPL3bJzGVFB08586cZdH4WM',
    appId: '1:93085748815:web:5e05dd0ae489e148dfa43a',
    messagingSenderId: '93085748815',
    projectId: 'movie-3f823',
    authDomain: 'movie-3f823.firebaseapp.com',
    storageBucket: 'movie-3f823.firebasestorage.app',
    measurementId: 'G-FT6WEPZY7B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkfr6ISSZDJwWhKd91OLnSDUGDmL1BVRA',
    appId: '1:93085748815:android:9a8e6ad2641aa590dfa43a',
    messagingSenderId: '93085748815',
    projectId: 'movie-3f823',
    storageBucket: 'movie-3f823.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRJPpdmAQegALd5yfoj0FD93Io0s3Thew',
    appId: '1:93085748815:ios:271661af85d2d84fdfa43a',
    messagingSenderId: '93085748815',
    projectId: 'movie-3f823',
    storageBucket: 'movie-3f823.firebasestorage.app',
    iosBundleId: 'com.yourdomain.movies',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRJPpdmAQegALd5yfoj0FD93Io0s3Thew',
    appId: '1:93085748815:ios:271661af85d2d84fdfa43a',
    messagingSenderId: '93085748815',
    projectId: 'movie-3f823',
    storageBucket: 'movie-3f823.firebasestorage.app',
    iosBundleId: 'com.yourdomain.movies',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9fptM5AN6QPL3bJzGVFB08586cZdH4WM',
    appId: '1:93085748815:web:0051cc97d88ba711dfa43a',
    messagingSenderId: '93085748815',
    projectId: 'movie-3f823',
    authDomain: 'movie-3f823.firebaseapp.com',
    storageBucket: 'movie-3f823.firebasestorage.app',
    measurementId: 'G-0SXJ4H1P61',
  );
}
