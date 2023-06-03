package com.example.flutter_star_printer_sdk

import android.app.Activity
import android.content.Context
import android.widget.Toast
import androidx.annotation.NonNull
import com.example.flutter_star_printer_sdk.Adapter.StarPrinterAdapter
import com.example.flutter_star_printer_sdk.Permissions.BluetoothPermissionManager
import com.example.flutter_star_printer_sdk.Utils.StarReceiptBuilder
import com.starmicronics.stario10.InterfaceType
import com.starmicronics.stario10.StarConnectionSettings
import com.starmicronics.stario10.StarPrinter
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*


/** FlutterStarPrinterSdkPlugin */
class FlutterStarPrinterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var starPrinterAdapter: StarPrinterAdapter

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "co.uk.ferns.flutter_plugins/flutter_star_printer_sdk"
        )
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        starPrinterAdapter = StarPrinterAdapter(context);
    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d("DART/NATIVE", "onAttachedToActivity")
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "discoverPrinter" -> {
                val args: Map<*, *> = call.arguments as Map<*, *>;
                val interfaces: List<*> = args["interfaces"] as List<*>;
                // Specify your printer interface types.
                val interfaceTypes: List<InterfaceType> = (interfaces.map {
                    when (it as String?) {
                        "lan" -> InterfaceType.Lan
                        "bluetooth" -> InterfaceType.Bluetooth
                        "usb" -> InterfaceType.Usb
                        else -> InterfaceType.Unknown
                    }
                }).toList();

                if (interfaceTypes.contains(InterfaceType.Bluetooth)) {
                    val bluetoothPermissionManager =
                        BluetoothPermissionManager(mContext = context, mActivity = activity);
                    if (!bluetoothPermissionManager.hasPermission()) {
                        bluetoothPermissionManager.requestPermission();
                    }
                }

                starPrinterAdapter.discoverPrinter(interfaceTypes, { printer ->
                    val printerMap = printerToMap(printer);
                    channel.invokeMethod("onDiscovered", printerMap);
                }) {
                    Toast.makeText(
                        context, "Discovery Finished", Toast.LENGTH_LONG
                    ).show()
                };

                result.success(null);
            }
            "connectPrinter" -> {
                val args = call.arguments as Map<*, *>
                val printer = printerFromArg(args);
                val response = runBlocking { starPrinterAdapter.connectPrinter(printer) }

                val error = response["error"] as String?
                val connected = response["connected"] as Boolean?

                result.apply {
                    when {
                        connected == true -> success(response)
                        connected == null || error != null -> error(
                            "Printer Error", error, response
                        )
                        else -> error(
                            "Printer Error",
                            "Unknown error occurred while connecting to the printer",
                            response
                        )
                    }
                }
            }
            "disconnectPrinter" -> {
                val args = call.arguments as Map<*, *>
                val printer = printerFromArg(args);
                val response = runBlocking { starPrinterAdapter.disconnectPrinter(printer) }

                val error = response["error"] as String?
                val disconnected = response["disconnected"] as Boolean?

                result.apply {
                    when {
                        disconnected == true -> success(response)
                        disconnected == null || error != null -> error(
                            "Printer Error", error, response
                        )
                        else -> error(
                            "Printer Error",
                            "Unknown error occurred while disconnecting the printer",
                            response
                        )
                    }
                }
            }
            "printDocument" -> {
                val args = call.arguments as Map<*, *>
                val printer = printerFromArg(args);
                val document = args["document"] as Map<*, *>
                val contents = document["contents"] as Collection<*>
                starPrinterAdapter.printDocument(printer, StarReceiptBuilder.buildReceipt(contents));
                result.success(true);
            }
            else -> result.notImplemented()
        }
    }


    private fun printerFromArg(args: Map<*, *>): StarPrinter {
        val interfaceType = getPrinterInterfaceType(args["interfaceType"] as String)
        val identifier = args["identifier"] as String
        val settings = StarConnectionSettings(interfaceType, identifier)
        return starPrinterAdapter.createPrinterInstance(settings, context);
    }


    private fun printerToMap(printer: StarPrinter): MutableMap<String, String> {
        val model = printer.information?.model?.name ?: "Unknown"
        val identifier = printer.connectionSettings.identifier
        val interfaceType = printer.connectionSettings.interfaceType.name

        return mutableMapOf(
            "model" to model, "identifier" to identifier, "connection" to interfaceType
        )
    }


    private fun getPrinterInterfaceType(interfaceType: String): InterfaceType =
        when (interfaceType) {
            "lan" -> InterfaceType.Lan
            "bluetooth" -> InterfaceType.Bluetooth
            "usb" -> InterfaceType.Usb
            else -> InterfaceType.Unknown
        }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
