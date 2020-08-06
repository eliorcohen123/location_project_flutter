package com.eliorcohen.locationprojectflutter

import android.content.Intent
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL = "com.eliorcohen.locationprojectflutter.channel"
        const val KEY_NATIVE = "showNativeView"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == KEY_NATIVE) {
                val intent = Intent(this, CreditActivity::class.java)
                startActivity(intent)
            }
        }
    }

}
