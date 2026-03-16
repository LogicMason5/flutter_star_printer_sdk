package com.example.flutter_star_printer_sdk.adapter

import android.content.Context
import com.starmicronics.stario10.*
import com.starmicronics.stario10.starxpandcommand.StarXpandCommandBuilder
import io.flutter.Log
import kotlinx.coroutines.*

class StarPrinterAdapter(private val context: Context) {

    companion object {
        private const val LOG_TAG = "Flutter Star SDK"
    }

    // Reusable coroutine scope (avoids leaks)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    private var discoveryManager: StarDeviceDiscoveryManager? = null

    // -------------------------------------------------
    // Create Printer Instance
    // -------------------------------------------------
    fun createPrinterInstance(
        connectionSettings: StarConnectionSettings
    ): StarPrinter {
        return StarPrinter(connectionSettings, context)
    }

    // -------------------------------------------------
    // Discover Printers
    // -------------------------------------------------
    fun discoverPrinter(
        interfaceTypes: List<InterfaceType>,
        onPrinterFound: (StarPrinter) -> Unit,
        onDiscoveryFinished: () -> Unit
    ) {
        try {
            discoveryManager?.stopDiscovery()

            discoveryManager = StarDeviceDiscoveryManagerFactory.create(
                interfaceTypes,
                context
            ).apply {
                discoveryTime = 10_000

                callback = object : StarDeviceDiscoveryManager.Callback {
                    override fun onPrinterFound(printer: StarPrinter) {
                        Log.d(LOG_TAG, "Found printer: ${printer.information?.model?.name}")
                        onPrinterFound(printer)
                    }

                    override fun onDiscoveryFinished() {
                        Log.d(LOG_TAG, "Discovery Finished")
                        onDiscoveryFinished()
                    }
                }
            }

            discoveryManager?.startDiscovery()

        } catch (e: Exception) {
            Log.e(LOG_TAG, "Discovery error", e)
        }
    }

    fun stopDiscovery() {
        discoveryManager?.stopDiscovery()
    }

    // -------------------------------------------------
    // Connect Printer
    // -------------------------------------------------
    private suspend fun connectPrinter(printer: StarPrinter): Result<Unit> {
        return try {
            printer.openAsync().await()
            Log.i(LOG_TAG, "Printer connected")
            Result.success(Unit)

        } catch (e: StarIO10Exception) {
            Log.e(LOG_TAG, "Connection failed", e)
            Result.failure(e)

        } catch (e: Exception) {
            Log.e(LOG_TAG, "Unknown connection error", e)
            Result.failure(e)
        }
    }

    // -------------------------------------------------
    // Disconnect Printer
    // -------------------------------------------------
    private suspend fun disconnectPrinter(printer: StarPrinter) {
        try {
            printer.closeAsync().await()
            Log.i(LOG_TAG, "Printer disconnected")
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Disconnection error", e)
        }
    }

    // -------------------------------------------------
    // Print Document (Safe Lifecycle)
    // -------------------------------------------------
    fun printDocument(
        printer: StarPrinter,
        builder: StarXpandCommandBuilder,
        onResult: (Boolean, String?) -> Unit
    ) {
        scope.launch {

            val commands = builder.getCommands()

            // 1️⃣ Connect
            val connection = connectPrinter(printer)

            if (connection.isFailure) {
                withContext(Dispatchers.Main) {
                    onResult(false, connection.exceptionOrNull()?.localizedMessage)
                }
                return@launch
            }

            try {
                // 2️⃣ Print
                printer.printAsync(commands).await()

                Log.i(LOG_TAG, "Print successful")

                withContext(Dispatchers.Main) {
                    onResult(true, null)
                }

            } catch (e: Exception) {

                Log.e(LOG_TAG, "Print failed", e)

                withContext(Dispatchers.Main) {
                    onResult(false, e.localizedMessage)
                }

            } finally {
                // 3️⃣ Always disconnect
                disconnectPrinter(printer)
            }
        }
    }

    // -------------------------------------------------
    // Cleanup (IMPORTANT for Flutter plugin lifecycle)
    // -------------------------------------------------
    fun release() {
        stopDiscovery()
        scope.cancel()
    }
}
