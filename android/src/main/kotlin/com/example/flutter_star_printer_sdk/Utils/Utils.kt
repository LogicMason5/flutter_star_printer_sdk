package com.example.flutter_star_printer_sdk.Utils

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.widget.Toast

class Utils {
    companion object {
        fun showToast(context: Context, message: String) {
            // Check if the current thread is the main thread.
            if (Looper.getMainLooper() != Looper.myLooper()) {
                // If the current thread is not the main thread, then run the toast on the main thread.
                Handler(Looper.getMainLooper()).post {
                    Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
                }
            } else {
                // If the current thread is the main thread, then show the toast directly.
                Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
            }
        }
    }

}