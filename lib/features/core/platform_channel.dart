import 'package:flutter/services.dart';

/// ## PlatformChannel
/// A utility class that provides a platform-specific channel for performing
/// operations that require native functionality. In this case, it handles
/// analyzing text input through a method channel.
///
/// ### Properties
/// - `_channel`: A `MethodChannel` used to communicate with the native platform
///   via the name `'com.example.flutter/hive_channel'`.
///
/// ### Methods
/// - `invokeAnalyze(String input)`: Sends the input text to the native platform
///   to perform analysis. Returns the analysis result as a `String`. If an error
///   occurs during the platform call, it returns an error message.



class PlatformChannel {
  static const MethodChannel _channel = MethodChannel('com.example.flutter/hive_channel');

  static Future<String> invokeAnalyze(String input) async {
    try {
      final String result = await _channel.invokeMethod('analyzeInput', {"input": input});
      return result;
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    }
  }
}
