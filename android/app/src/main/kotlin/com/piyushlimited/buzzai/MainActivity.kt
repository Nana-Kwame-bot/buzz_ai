package com.piyushlimited.buzzai

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private lateinit var sensorManager: SensorManager
    private lateinit var channel: MethodChannel
    private val LIST_SENSOR_CHANNEL = "buzzai/sensor_data"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LIST_SENSOR_CHANNEL)

        channel.setMethodCallHandler {call, result ->
            if (call.method == "accelerometer_max_range") {
                // val arguments = call.arguments() as Map<String, String>
                val maxAcc = getSensorList()
                result.success(maxAcc)
            }
        }
    }

    private fun getSensorList(): Float {
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val accelerometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        return accelerometerSensor.maximumRange
    }
}
