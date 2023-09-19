# Flutter Integration SDK

This Flutter Integration SDK contains code to help you use our Native/Web SDKs from Flutter.

Tested with Flutter 3.13.4, Dart 3.1.2, DevTools 2.25.0, Xcode 15.0.

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

#### - Step 1: Download the code
Download the `flutter-tools` folder from our github repo [flutter-integration-sdk](https://github.com/Mopinion-com/flutter-integration-sdk/archive/refs/heads/main.zip). 

#### - Step 2: Add the code to your Native side project
- Open your Xcode project (default is ios/Runner.xcworkspace).
- From the downloaded `flutter-tools/ios` folder, copy the `MopinionFlutterPlugin.swift` file somewhere into your Xcode main project. For example to the main folder of the `Runner` project of a default Flutter generated project.
- In your `AppDelegate.swift` file, add a line for the method `MopinionFlutterBridge.shared.mopinionSdkBind()`. This will bind the Native project with the Flutter project and will receive the desired events.

Here is an example of the `AppDelegate.swift`:

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    MopinionFlutterBridge.shared.mopinionSdkBind()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### - Step 3: Add the MopinionSDK to your Xcode project
- If your iOS project uses a podspec file, add the following line above the `end` :

```
  s.dependency 'MopinionSDKWeb', '>= 0.6.0'
```

P.S: Flutter uses iOS 11 by default, which our MopinionSDKWeb supports. You can also use our fully native MopinionSDK version 1.0.2 or higher, but that requires upgrading your Flutter project to iOS 12 :

```
  s.dependency 'MopinionSDK', '>= 1.0.2'
```

- Alternatively, you can manually add one of our iOS SDK's to your Xcode project via swift package manager. See instructions for [MopinionSDKWeb](https://github.com/mopinion/mopinion-sdk-ios-web/releases) or the [native MopinionSDK](https://github.com/mopinion-com/mopinion-sdk-ios-swiftpm).

### Flutter Implementation Steps

#### - Step 1: Place the bridge into the Flutter project
- From the downloaded folder `flutter-tools`, copy the file `flutter-package/MopinionFlutterBridge.dart`  to your Flutter project.
It contains the class with all the methods that the SDK can perform. 

#### - Step 2: Initialise the Mopinion Native SDK from Flutter
- Add a single call to `initSdk()`, to make the SDK ready to use, preferrably during the start your project as for example:

```dart
    //example class: main.dart

    MopinionFlutterBridge.initSdk(String DEPLOYMENT_KEY, bool log)
```

This should happen before using any of the other SDK  methods, as they expect the SDK to be initialised. 

P.S: The functions of `MopinionFlutterBridge.dart` are static, thus there is no need of initialise it as an object. Once this is accomplished, the SDK is initialised and ready to use.

#### - Step 3: Invoke form events
Once the SDK is initialised, you can invoke our form events from any View class of the Flutter project, as the following example:

```dart
    //example class: main.dart

    // .event will receive a EVENT_NAME you have previously 
    // created on the Mopinion interface.
    MopinionFlutterBridge.event(EVENT_NAME);

```

#### Using metadata

- The method `data` from MopinionFlutterBridge will receive a `Map<String, String>` as parameted for the metadata.
- The method `removeMetadata` from `MopinionFlutterBridge` will receive a key as `String` to delete the key metadata you refer to.
- The method `removeAllMetadata` from `MopinionFlutterBridge` will remove all the metadata stored previously.

```dart
    //example class: main.dart

    //.data will receive a Map<String, String> as key and value map, which will add metadata to the form.
    Map<String, String> metadataMap = {
        "age": "29",
        "name": "Manuel"
    };
    MopinionFlutterBridge.data(metadataMap);
```


