import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAYQIGxwnoKZ7joEPgFahD89i9yG6HfaRE',
    appId: '1:357031755557:web:3bafff211697899ee724cc',
    messagingSenderId: '357031755557',
    projectId: 'bitebank-9ec76',
    authDomain: 'bitebank-9ec76.firebaseapp.com',
    storageBucket: 'bitebank-9ec76.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgAVTNEjq8h4HczgJ07g2_CptHGAsVXA8',
    appId: '1:357031755557:android:96310fbe7d8ece74e724cc',
    messagingSenderId: '357031755557',
    projectId: 'bitebank-9ec76',
    storageBucket: 'bitebank-9ec76.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD92F9DZhNcyBgJL9ArCo40kGb4YyDLFVY',
    appId: '1:357031755557:ios:009f203af4d44872e724cc',
    messagingSenderId: '357031755557',
    projectId: 'bitebank-9ec76',
    storageBucket: 'bitebank-9ec76.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplicationBitebank',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD92F9DZhNcyBgJL9ArCo40kGb4YyDLFVY',
    appId: '1:357031755557:ios:009f203af4d44872e724cc',
    messagingSenderId: '357031755557',
    projectId: 'bitebank-9ec76',
    storageBucket: 'bitebank-9ec76.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplicationBitebank',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAYQIGxwnoKZ7joEPgFahD89i9yG6HfaRE',
    appId: '1:357031755557:web:36df92b49c779277e724cc',
    messagingSenderId: '357031755557',
    projectId: 'bitebank-9ec76',
    authDomain: 'bitebank-9ec76.firebaseapp.com',
    storageBucket: 'bitebank-9ec76.firebasestorage.app',
  );

}