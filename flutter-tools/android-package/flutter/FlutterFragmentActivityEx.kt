package com.mopinion.flutter_bridge.flutter

import android.util.Log
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.CHANNEL
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.FIRST_ARGUMENT
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.KEY
import com.mopinion.flutter_bridge.flutter.MopinionFlutterBridgeConstants.VALUE
import com.mopinion.mopinion_android_sdk.ui.mopinion.Mopinion
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private lateinit var mopinion: Mopinion

fun FlutterFragmentActivity.loadMopinionFlutterBridge(flutterEngine: FlutterEngine) {
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
        var counter = 0
        when(MopinionActions.map[call.method]) {
            MopinionActions.InitialiseSDK -> {
                val deploymentKey = call.argument(DEPLOYMENT_KEY) as String? ?: return@setMethodCallHandler
                val isLogActive = call.argument(LOG) as Boolean? ?: return@setMethodCallHandler
                Mopinion.initialiseFromFlutter(
                    application = this.application,
                    deploymentKey = deploymentKey,
                    log = isLogActive
                )
            }
            MopinionActions.TriggerEvent -> {
                val eventName = call.argument(FIRST_ARGUMENT) as String? ?: return@setMethodCallHandler
                mopinion = Mopinion(this, this)
                mopinion.event(eventName) {
                    if (counter == 0) {
                        Log.d("FlutterFragmentActivity", it::class.java.simpleName)
                        result.success(it::class.java.simpleName)
                        counter ++
                    }
                }
            }
            MopinionActions.AddMetaData -> {
                if (::mopinion.isInitialized) {
                    val key = call.argument(KEY) as String? ?: return@setMethodCallHandler
                    val value = call.argument(VALUE) as String? ?: return@setMethodCallHandler
                    mopinion.data(key, value)
                }
            }
            MopinionActions.RemoveAllMetaData -> {
                mopinion.removeData()
            }
            MopinionActions.RemoveMetaData -> {
                val key = call.argument(KEY) as String? ?: return@setMethodCallHandler
                mopinion.removeData(key)
            }
            null -> {}
        }
    }
}