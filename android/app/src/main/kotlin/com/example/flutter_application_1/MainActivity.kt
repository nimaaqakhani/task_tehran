package com.example.flutter_application_1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.flutter/hive_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // فقط این خط کافیه! (در نسخه 5.0.0+)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // MethodChannel برای analyzeInput
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "analyzeInput" -> {
                        val input = call.argument<String>("input") ?: ""
                        result.success(analyzeInput(input))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun analyzeInput(input: String?): String {
        if (input.isNullOrEmpty()) return "Empty input"
        val letters = input.count { it.isLetter() }
        val words = if (input.trim().isEmpty()) 0 else input.trim().split("\\s+".toRegex()).size
        return "Letters: $letters, Words: $words"
    }
}