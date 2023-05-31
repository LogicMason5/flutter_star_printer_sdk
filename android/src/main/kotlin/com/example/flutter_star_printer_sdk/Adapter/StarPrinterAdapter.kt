package com.example.flutter_star_printer_sdk.Adapter

import android.content.Context
import android.widget.Toast
import com.starmicronics.stario10.*
import com.starmicronics.stario10.starxpandcommand.*
import com.starmicronics.stario10.starxpandcommand.printer.*
import io.flutter.Log

class StarPrinterAdapter(private val mContext: Context) {

    private val LOG_TAG = "Flutter Star SDK"

    private var _manager: StarDeviceDiscoveryManager? = null

    fun discoverPrinter(
        interfaceTypes: List<InterfaceType>, onPrinterFound: ((printer: StarPrinter) -> Unit),
        onDiscoveryFinished: () -> Unit
    ) {
        try {
            this._manager?.stopDiscovery()
            _manager = StarDeviceDiscoveryManagerFactory.create(
                interfaceTypes, mContext
            )

            _manager?.discoveryTime = 10000
            _manager?.callback = object : StarDeviceDiscoveryManager.Callback {
                override fun onPrinterFound(printer: StarPrinter) {
                    Log.d(LOG_TAG, "Found printer: ${printer.information?.model?.name}.")
                    onPrinterFound.invoke(printer);
                }

                override fun onDiscoveryFinished() {
                    Log.d(LOG_TAG, "Discovery Finished.")
                    onDiscoveryFinished.invoke();
                }
            }

            _manager?.startDiscovery()

        } catch (e: StarIO10IllegalHostDeviceStateException) {
            Log.d(LOG_TAG, "Star Error: $e")
        } catch (e: Exception) {
            Log.d(LOG_TAG, "Error: $e")
        }
    }
}