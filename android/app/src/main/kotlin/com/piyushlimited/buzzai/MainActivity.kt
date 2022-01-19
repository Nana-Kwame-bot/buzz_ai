package com.piyushlimited.buzzai

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Bundle
import android.widget.TextView
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
                val sensorList = getSensorList()
                var accelerometerMaxRange = 0f;
                
                for (sensor in sensorList) {
                    if (sensor.name.toLowerCase().contains("accelerometer")) {
                        accelerometerMaxRange = sensor.maximumRange
                    }
                }

                result.success(accelerometerMaxRange)
            }
        }
    }

    private fun getSensorList(): List<Sensor> {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val deviceSensors: List<Sensor> = sensorManager.getSensorList(Sensor.TYPE_ALL)

        return deviceSensors
    }
}
