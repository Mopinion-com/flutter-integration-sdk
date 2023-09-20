//
//  MopinionFlutterBridge.swift
//  Runner
//
//  Created by Manuel Crovetto on 17/08/2023.
//

import Foundation
import Flutter
import MopinionSDK

// singleton to pass messages with arguments from flutter to the MopinionSDK
@objc public class MopinionFlutterBridge: NSObject {
    
    private let METHOD_CHANNEL_NAME = "MopinionFlutterBridge/native"    // flutter communication channel

    private struct MopinionFlutterBridgeError {
        let code : String
        let message : String
        
        init(code: String, message: String) {
            self.code = code        // short keywword like errornumber or alphanumeric classification
            self.message = message  // brief human readable description of the error classication
        }
    }
    
    private let invalidArgError = MopinionFlutterBridgeError(code:"invalidArgs", message: "Invalid arguments.")
    
    private enum MopinionFlutterAction: String {
        case INIT_WITH_DEPLOYMENT = "init_sdk"
        case ADD_META_DATA = "add_meta_data"
        case REMOVE_META_DATA = "remove_meta_data"
        case REMOVE_ALL_META_DATA = "remove_all_meta_data"
        case TRIGGER_EVENT = "trigger_event"
    }

    private enum MopinionFlutterArgument: String {
        case DEPLOYMENT_KEY = "deployment_key"
        case FIRST_ARGUMENT = "argument1"
        case KEY = "key"
        case LOG = "log"
        case VALUE = "value"
    }

    // statics for the Flutter message communication
    private weak static var controller : FlutterViewController?
    private weak static var channel : FlutterMethodChannel?
    
    // MARK: singleton
    private override init() {}  // singleton
    
    static let shared = MopinionFlutterBridge()
    
    // MARK: Flutter method handler
    
    // Actual message handler. Call this for instance from your (Flutter)AppDelegate
    func mopinionSdkBind() {
        guard let controller = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController else {
            MopinionFlutterBridge.controller = nil
            return
        }
        MopinionFlutterBridge.controller = controller
        let channel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
        MopinionFlutterBridge.channel = channel
        
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
            case MopinionFlutterAction.INIT_WITH_DEPLOYMENT.rawValue :
                self?.initializeSdk(call: call, result: result)
                break
            case MopinionFlutterAction.TRIGGER_EVENT.rawValue:
                self?.triggerEvent(controller:controller, call: call, result: result)
                break
            case MopinionFlutterAction.ADD_META_DATA.rawValue:
                self?.addMetaData(controller: controller, call: call, result: result)
                break
            case MopinionFlutterAction.REMOVE_META_DATA.rawValue:
                self?.removeMetadataWithKey(controller: controller, call: call, result: result)
                break
            case MopinionFlutterAction.REMOVE_ALL_META_DATA.rawValue:
                self?.removeAllMetadata()
                break
            default:
                break
            }
        })
    }
    
    // MARK: implementation of the Flutter methods

    private func initializeSdk(call: FlutterMethodCall, result: FlutterResult) {
        guard let deploymentKey = (call.arguments as? Dictionary<String, AnyObject>)?[MopinionFlutterArgument.DEPLOYMENT_KEY.rawValue] as? String else {
            result(FlutterError(code: invalidArgError.code, message: "\(invalidArgError.message) \(MopinionFlutterArgument.DEPLOYMENT_KEY.rawValue)", details: "Expected deployment key as String"))
            return
        }
        guard let enableLogging = (call.arguments as? Dictionary<String, AnyObject>)?[MopinionFlutterArgument.LOG.rawValue] as? Bool else {
            result(FlutterError(code: invalidArgError.code, message: "\(invalidArgError.message) \(MopinionFlutterArgument.LOG.rawValue)", details: "Expected log to be bool (true or false)"))
            return
        }
        MopinionSDK.load(deploymentKey, enableLogging)
        result(nil)
    }

    private func triggerEvent(controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
        guard let eventName = (call.arguments as? Dictionary<String, AnyObject>)?[MopinionFlutterArgument.FIRST_ARGUMENT.rawValue] as? String else {
            result(FlutterError(code: invalidArgError.code, message: "\(invalidArgError.message) \(MopinionFlutterArgument.DEPLOYMENT_KEY.rawValue)", details: "Expected event name as String"))
            return
        }
        MopinionSDK.event(controller, eventName)
        result(nil)
    }

    private func addMetaData(controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
        guard let key = (call.arguments as? Dictionary<String, AnyObject>)?[MopinionFlutterArgument.KEY.rawValue] as? String else {
            result(FlutterError(code: invalidArgError.code, message: "\(invalidArgError.message) \(MopinionFlutterArgument.KEY.rawValue)", details: "Expected key value for map of metadata."))
            return
        }
        guard let value = (call.arguments as? Dictionary<String, AnyObject>)?[MopinionFlutterArgument.VALUE.rawValue] as? String else {
            result(FlutterError(code: invalidArgError.code, message: "\(invalidArgError.message) \(MopinionFlutterArgument.VALUE.rawValue)", details: "Expected value for map of metadata."))
            return
        }
        MopinionSDK.data(key, value)
    }

    private func removeMetadataWithKey(controller: FlutterViewController, call: FlutterMethodCall, result: FlutterResult) {
        guard let key = (call.arguments as? Dictionary<String, AnyObject>)?[MopinionFlutterArgument.KEY.rawValue] as? String else {
            result(FlutterError(code: invalidArgError.code, message: "\(invalidArgError.message) \(MopinionFlutterArgument.KEY.rawValue)", details: "Expected key value for map of metadata."))
            return
        }
        MopinionSDK.removeData(forKey: key)
    }

    private func removeAllMetadata() {
        MopinionSDK.removeData()
    }
}
