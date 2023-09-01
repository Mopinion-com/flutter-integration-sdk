//
//  MopinionFlutterPlugin.swift
//  Runner
//
//  Created by Manuel Crovetto on 17/08/2023.
//

import Foundation
import Flutter
import MopinionSDK

private let methodChannelName = "MopinionFlutterBridge/native"
private let initSdkAction = "init_sdk"
private let triggerEventAction = "trigger_event"
private let addMetaDataAction = "add_meta_data"
private let removeMetaDataAction = "remove_meta_data"
private let removeAllMetaDataAction = "remove_all_meta_data"
private let deploymentKeyArgument = "deployment_key"
private let firstArgument = "argument1"
private let errorCode = "invalidArgs"
private let errorMessage = "Invalid arguments."
private let key = "key"
private let value = "value"

extension FlutterAppDelegate {
    
    func mopinionSdkBind() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case initSdkAction :
                initializeSdk(call: call, result: result)
                break
            case triggerEventAction:
                triggerEvent(controller: controller, call: call, result: result)
                break
            case addMetaDataAction:
                addMetaData(controller: controller, call: call, result: result)
                break
            case removeMetaDataAction:
                removeMetadataWithKey(controller: controller, call: call, result: result)
                break
            case removeAllMetaDataAction:
                removeAllMetadata()
                break
            default:
                break
            }
        })
    }
}

private func initializeSdk(call: FlutterMethodCall, result: FlutterResult) {
    guard let deploymentKey = (call.arguments as? Dictionary<String, AnyObject>)?[deploymentKeyArgument] as? String else {
        result(FlutterError(code: errorCode, message: "\(errorMessage) \(deploymentKeyArgument)", details: "Expected deployment key as String"))
        return
    }
    MopinionSDK.load(deploymentKey, true)
    result(nil)
}

private func triggerEvent(controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
    guard let eventName = (call.arguments as? Dictionary<String, AnyObject>)?[firstArgument] as? String else {
        result(FlutterError(code: errorCode, message: "\(errorMessage) \(deploymentKeyArgument)", details: "Expected event name as String"))
        return
    }
    MopinionSDK.event(controller, eventName)
    result(nil)
}

private func addMetaData(controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
    guard let key = (call.arguments as? Dictionary<String, AnyObject>)?[key] as? String else {
        result(FlutterError(code: errorCode, message: "\(errorMessage) \(deploymentKeyArgument)", details: "Expected key value for map of metadata."))
        return
    }
    guard let value = (call.arguments as? Dictionary<String, AnyObject>)?[value] as? String else {
        result(FlutterError(code: errorCode, message: "\(errorMessage) \(deploymentKeyArgument)", details: "Expected value for map of metadata."))
        return
    }
    MopinionSDK.data(key, value)
}

private func removeMetadataWithKey(controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
    guard let key = (call.arguments as? Dictionary<String, AnyObject>)?[key] as? String else {
        result(FlutterError(code: errorCode, message: "\(errorMessage) \(deploymentKeyArgument)", details: "Expected key value for map of metadata."))
        return
    }
    MopinionSDK.removeData(forKey: key)
}

private func removeAllMetadata() {
    MopinionSDK.removeData()
}
