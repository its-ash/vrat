package com.itsash.vrat

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Dart sends the upcoming observances as JSON; store them and redraw the widget.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.itsash.vrat/widget")
            .setMethodCallHandler { call, result ->
                if (call.method == "update") {
                    VratWidget.save(this, call.arguments as? String ?: "")
                    VratWidget.updateAll(this)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
