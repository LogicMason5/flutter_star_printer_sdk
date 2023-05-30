package com.example.flutter_star_printer_sdk.Permissions

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat.checkSelfPermission

class BluetoothPermissionManager(private val mContext: Context, private val mActivity: Activity) {
    private val requestCode = 1000

    fun requestPermission() {
        if (checkSelfPermission(
                mContext, android.Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(
                mActivity,
                arrayOf(
                    android.Manifest.permission.BLUETOOTH_CONNECT,
                ), requestCode
            )
        }
    }

    fun hasPermission(): Boolean {
        return checkSelfPermission(
            mContext, android.Manifest.permission.BLUETOOTH_CONNECT
        ) == PackageManager.PERMISSION_GRANTED
    }
}