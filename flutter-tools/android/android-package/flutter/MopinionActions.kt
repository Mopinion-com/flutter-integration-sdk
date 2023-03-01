package com.mopinion.flutter_bridge.flutter

import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.ADD_META_DATA
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.TRIGGER_EVENT
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.INITIALISE_SDK
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.REMOVE_ALL_META_DATA
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.REMOVE_META_DATA

sealed interface MopinionActions {
    object InitialiseSDK: MopinionActions
    object TriggerEvent: MopinionActions
    object AddMetaData: MopinionActions
    object RemoveMetaData: MopinionActions
    object RemoveAllMetaData: MopinionActions
    companion object {
        val map = hashMapOf(
            INITIALISE_SDK to InitialiseSDK,
            TRIGGER_EVENT to TriggerEvent,
            ADD_META_DATA to AddMetaData,
            REMOVE_META_DATA to RemoveMetaData,
            REMOVE_ALL_META_DATA to RemoveAllMetaData
        )
    }
}