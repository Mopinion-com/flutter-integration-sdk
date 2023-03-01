# Flutter Integration SDK

This Flutter Integration SDK contains a package of tools which can be helpful to be able to use our Native SDKs.

### Android Native Implementation Steps
#### - Step 1: Download the package
Download the `flutter-tools` package which can be found in this repository.

#### - Step 2: Add the package to your Native side project
Add the `flutter` package to your Android Native Root Project. 
This package contains the extension function `.loadMopinionFlutterBridge(flutterEngine: FlutterEngine)`, this function is responsible of handle the `Method Channel` from Flutter and perform actions on the Native SDK.

#### - Step 3: Implement the bridge in the Native project
In your Android Native Project, your MainActivity.kt (or equivalent) has to extend from `FlutterFragmentActivity`. 
You can call `loadMopinionFlutterBdrige(flutterEngine)` in the `override` method `configureFlutterEngine(flutterEngine: FlutterEngine)` as the following:
```
    @ExperimentalStdlibApi
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        loadMopinionFlutterBridge(flutterEngine)
    }
```

### iOS Native Implementation

Currently, we are working on the iOS  Flutter integration SDK, it will be published as soon as it is production ready.

### Flutter Implementation Steps

#### - Step 1: Place the bridge into the Flutter project
Inside the initial package `flutter-tools` there is a package called `flutter-package`, in this package you can find the `MopinionFlutterBridge.dart` class.
This class contains all the methods that the SDK can perform. You can place this class into your Flutter project in the package of your like, just keep in mind you will declare it and initialise it in multiple parts of your Flutter project.

#### - Step 2: Initialise the Mopinion Native SDK from Flutter
Before calling the form events we need to initialise the Native SDK, for that in our main.dart (or where the system starts in your project) we need to initialise the `MopinionFlutterBridge` class and access to its methods, and the first method we want to call when the system starts, is the `initSdk`, as the following example:

```
    //example class: main.dart
    MopinionFlutterBridge flutterBridge = MopinionFlutterBridge();

    flutterBridge.initSdk(String DEPLOYMENT_KEY, bool log)
```

Once this is accomplished, the SDK is initialised and ready to use.

#### - Step 3: Invoke form events
Once the SDK is initialised, we can proceed to invoke our form events from any View class of the Flutter project, as the following example:

```
    //example class: main.dart
     MopinionFlutterBridge flutterBridge = MopinionFlutterBridge();

    // .event will receive a EVENT_NAME you have previously 
    // created on the Mopinion interface.
    flutterBridge.event(EVENT_NAME).then((formState) {
        //the SDK returns a form state to indicate in which 
        // state the form is.

        // code
    });
```

#### Using metadata

The method `data` from MopinionFlutterBridge will receive a `Map` as parameted for the metadata.
The method `removeMetadata` from `MopinionFlutterBridge` will receive a key as `String` to delete the key metadata you refer to.
The method `removeAllMetadata` from `MopinionFlutterBridge` will remove all the metadata stored previously.


