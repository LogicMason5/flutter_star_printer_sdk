package com.example.flutter_star_printer_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.example.flutter_star_printer_sdk.Adapter.StarPrinterAdapter
import com.example.flutter_star_printer_sdk.Permissions.BluetoothPermissionManager
import com.example.flutter_star_printer_sdk.Utils.StarReceiptBuilder
import com.starmicronics.stario10.InterfaceType
import com.starmicronics.stario10.StarConnectionSettings
import com.starmicronics.stario10.StarPrinter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.*

class FlutterStarPrinterSdkPlugin : FlutterPlugin,
    MethodChannel.MethodCallHandler,
    ActivityAware,
    PluginRegistry.RequestPermissionsResultListener {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private lateinit var starPrinterAdapter: StarPrinterAdapter

    /// Coroutine scope tied to plugin lifecycle
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    // ---------- ENGINE ----------

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            binding.binaryMessenger,
            "co.uk.ferns.flutter_plugins/flutter_star_printer_sdk"
        )
        channel.setMethodCallHandler(this)

        context = binding.applicationContext
        starPrinterAdapter = StarPrinterAdapter(context)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        scope.cancel()
        channel.setMethodCallHandler(null)
    }

    // ---------- ACTIVITY ----------

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    // ---------- METHOD CALLS ----------

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {

        when (call.method) {

            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "discoverPrinter" -> handleDiscover(call, result)

            "connectPrinter" -> handleConnect(call, result)

            "disconnectPrinter" -> handleDisconnect(call, result)

            "printDocument" -> handlePrint(call, result)

            else -> result.notImplemented()
        }
    }

    // ---------- DISCOVER ----------

    private fun handleDiscover(call: MethodCall, result: MethodChannel.Result) {

        val args = call.arguments as Map<*, *>
        val interfaces = args["interfaces"] as List<*>

        val interfaceTypes = interfaces.map {
            when (it as String?) {
                "lan" -> InterfaceType.Lan
                "bluetooth" -> InterfaceType.Bluetooth
                "usb" -> InterfaceType.Usb
                else -> InterfaceType.Unknown
            }
        }

        if (interfaceTypes.contains(InterfaceType.Bluetooth)) {
            activity?.let {
                val permissionManager = BluetoothPermissionManager(context, it)
                if (!permissionManager.hasPermission()) {
                    permissionManager.requestPermission()
                }
            }
        }

        starPrinterAdapter.discoverPrinter(interfaceTypes,
            onPrinterFound = { printer ->
                channel.invokeMethod("onDiscovered", printerToMap(printer))
            },
            onFinished = {}
        )

        result.success(null)
    }

    // ---------- CONNECT ----------

    private fun handleConnect(call: MethodCall, result: MethodChannel.Result) {
        val printer = printerFromArg(call.arguments as Map<*, *>)

        scope.launch {
            try {
                val response = starPrinterAdapter.connectPrinter(printer)
                result.success(response)
            } catch (e: Exception) {
                result.error("CONNECT_ERROR", e.message, null)
            }
        }
    }

    // ---------- DISCONNECT ----------

    private fun handleDisconnect(call: MethodCall, result: MethodChannel.Result) {
        val printer = printerFromArg(call.arguments as Map<*, *>)

        scope.launch {
            try {
                val response = starPrinterAdapter.disconnectPrinter(printer)
                result.success(response)
            } catch (e: Exception) {
                result.error("DISCONNECT_ERROR", e.message, null)
            }
        }
    }

    // ---------- PRINT ----------

    private fun handlePrint(call: MethodCall, result: MethodChannel.Result) {

        val args = call.arguments as Map<*, *>
        val printer = printerFromArg(args)
        val document = args["document"] as Map<*, *>
        val contents = document["contents"] as Collection<*>

        scope.launch {
            try {
                starPrinterAdapter.printDocument(
                    printer,
                    StarReceiptBuilder.buildReceipt(contents)
                )
                result.success(true)
            } catch (e: Exception) {
                result.error("PRINT_ERROR", e.message, null)
            }
        }
    }

    // ---------- HELPERS ----------

    private fun printerFromArg(args: Map<*, *>): StarPrinter {
        val interfaceType = getPrinterInterfaceType(args["interfaceType"] as String)
        val identifier = args["identifier"] as String
        val settings = StarConnectionSettings(interfaceType, identifier)
        return starPrinterAdapter.createPrinterInstance(settings, context)
    }

    private fun printerToMap(printer: StarPrinter): Map<String, String> {
        val model = printer.information?.model?.name ?: "Unknown"
        val identifier = printer.connectionSettings.identifier
        val interfaceType = printer.connectionSettings.interfaceType.name

        return mapOf(
            "model" to model,
            "identifier" to identifier,
            "connection" to interfaceType
        )
    }

    private fun getPrinterInterfaceType(type: String): InterfaceType =
        when (type) {
            "lan" -> InterfaceType.Lan
            "bluetooth" -> InterfaceType.Bluetooth
            "usb" -> InterfaceType.Usb
            else -> InterfaceType.Unknown
        }

    // ---------- PERMISSIONS ----------

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        return false
    }
}
