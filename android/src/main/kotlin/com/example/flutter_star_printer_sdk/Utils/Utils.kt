package com.example.flutter_star_printer_sdk.utils

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.widget.Toast

object Utils {

    // -------------------------------------------------
    // Toast (Thread-safe)
    // -------------------------------------------------
    fun showToast(context: Context, message: String) {

        if (Looper.myLooper() == Looper.getMainLooper()) {
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
        } else {
            Handler(Looper.getMainLooper()).post {
                Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
            }
        }
    }

    // -------------------------------------------------
    // Fixed Length String (Left + Right alignment)
    // Example: ["Item", "10.00"] → "Item      10.00"
    // -------------------------------------------------
    fun convertToFixedLengthString(
        input: List<String>,
        targetLength: Int
    ): String {

        require(input.size >= 2) {
            "Input must contain at least 2 elements"
        }

        val left = input.first()
        val right = input.last()

        val totalTextLength = left.length + right.length

        require(totalTextLength <= targetLength) {
            "Text length exceeds target length"
        }

        val spaces = " ".repeat(targetLength - totalTextLength)

        return left + spaces + right
    }

    // -------------------------------------------------
    // Multi-Column Fixed Rows (Receipt Layout)
    // ratios → 12-grid system (like Bootstrap)
    // maxPaperSize → characters per line (e.g. 48 for 80mm paper)
    // -------------------------------------------------
    fun convertStringToFixedLengthRows(
        ratios: List<Int>,
        values: List<String>,
        maxPaperSize: Int = 48
    ): String {

        require(ratios.isNotEmpty()) { "Ratios cannot be empty" }
        require(ratios.size == values.size) {
            "Ratios and values must have the same size"
        }
        require(ratios.sum() <= 12) {
            "Total column width must be <= 12"
        }

        // Calculate column widths
        val columnWidths = ratios.map {
            (it / 12f * maxPaperSize).toInt()
        }

        val builder = StringBuilder(maxPaperSize)

        for (i in values.indices) {

            val width = columnWidths[i]
            val value = values[i]

            require(value.length <= width) {
                "Value \"$value\" exceeds column width $width"
            }

            val formatted = if (i == values.lastIndex) {
                // Right align last column
                value.padStart(width, ' ')
            } else {
                // Left align other columns
                value.padEnd(width, ' ')
            }

            builder.append(formatted)
        }

        return builder.toString()
    }
}
