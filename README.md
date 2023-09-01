# Flutter Integration SDK

This Flutter Integration SDK contains a package of tools which can be helpful to be able to use our Native SDKs.

### Android Native Implementation Steps
#### - Step 1: Download the package
Download the `flutter-tools` package which can be found in this repository.

#### - Step 2: Add the package to your Native side project
In the `android` package, find the `flutter` package and add it to your Android Native Root Project. 
This package contains the extension function `.loadMopinionFlutterBridge(flutterEngine: FlutterEngine)`, this function is responsible of handle the `Method Channel` from Flutter and perform actions on the Native SDK.

#### - Step 3: Implement the bridge in the Native project
In your Android Native Project, your MainActivity.kt (or equivalent) has to extend from `FlutterFragmentActivity`. 
You can call `loadMopinionFlutterBdrige(flutterEngine)` in the `override` method `configureFlutterEngine(flutterEngine: FlutterEngine)` as the following:
```kotlin
    @ExperimentalStdlibApi
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        loadMopinionFlutterBridge(flutterEngine)
    }
```

### iOS Native Implementation

#### - Step 1: Download the package
Download the `flutter-tools` package which can be found in this repository.

#### - Step 2: Add the package to your Native side project
In the `ios` package, find the `MopinionFlutterPlugin.swift` file, this file can be placed in the native root project, for example.
In your `AppDelegate.swift` file you can use the function `mopinionSdkBind()` which will bind the Native project with the flutter project and will receive the desired events.

Here is an example of the `AppDelegate.swift`:
```swift
import UIKit
import Flutter
import MopinionSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    mopinionSdkBind()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Flutter Implementation Steps

#### - Step 1: Place the bridge into the Flutter project
Inside the initial package `flutter-tools` there is a package called `flutter-package`, in this package you can find the `MopinionFlutterBridge.dart` class.
This class contains all the methods that the SDK can perform. You can place this class into your Flutter project in the package of your like. 

#### - Step 2: Initialise the Mopinion Native SDK from Flutter
Before calling the form events we need to initialise the Native SDK, and the first method we want to call when the system starts, is the `initSdk`, as the following example:

```dart
    //example class: main.dart

    MopinionFlutterBridge.initSdk(String DEPLOYMENT_KEY, bool log)
```

The functions of `MopinionFlutterBridge.dart` are static, thus there is no need of initialise it as an object. Once this is accomplished, the SDK is initialised and ready to use.

#### - Step 3: Invoke form events
Once the SDK is initialised, we can proceed to invoke our form events from any View class of the Flutter project, as the following example:

```dart
    //example class: main.dart

    // .event will receive a EVENT_NAME you have previously 
    // created on the Mopinion interface.
    MopinionFlutterBridge.event(EVENT_NAME);

    //.data will receive a Map<String, String> as key and value map, which will add metadata to the form.
    Map<String, String> metadataMap = {
        "age": "29",
        "name": "Manuel"
    };
    MopinionFlutterBridge.data(metadataMap);
```

#### Using metadata

The method `data` from MopinionFlutterBridge will receive a `Map<String, String>` as parameted for the metadata.
The method `removeMetadata` from `MopinionFlutterBridge` will receive a key as `String` to delete the key metadata you refer to.
The method `removeAllMetadata` from `MopinionFlutterBridge` will remove all the metadata stored previously.


