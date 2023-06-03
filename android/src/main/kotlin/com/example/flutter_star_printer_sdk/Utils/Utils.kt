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

        fun convertToFixedLengthString(input: List<String>, targetLength: Int): String {

            val sum = input.fold(0) { previousValue, element -> previousValue + element.length }

            val diff = targetLength - sum

            val whiteSpaceArray = ArrayList<String>()

            for (i in 0 until diff) {
                whiteSpaceArray.add(" ")
            }

            whiteSpaceArray.add(0, input.first())
            whiteSpaceArray.add(whiteSpaceArray.size, input.last())
            return whiteSpaceArray.joinToString(separator = "");
        }

        fun convertStringToFixedLengthRows(ratios: List<Int>, values: List<String>, maxPaperSize: Int = 48): String {

            // Check if the total columns width is equal to 12.
            if (ratios.sum() > 12) {
                throw Exception("Total columns width must be equal to 12")
            }

            // Calculate the column widths.
            val colInd = mutableListOf<Int>()
            for (ratio in ratios) {
                val sum = (ratio / 12f * maxPaperSize).toInt()
                colInd.add(sum)
            }

            // Create a list to store the formatted values.
            val finalArray = mutableListOf<String>()

            // Iterate over the column widths and values.
            for ((index, targetSpaceInRow) in colInd.withIndex()) {
                var value: String = values[index]
                val diff = targetSpaceInRow - value.length

                // Check if the value is longer than the column width.
                if (value.length > targetSpaceInRow) {
                    throw Exception("Value must be length of available space")
                }

                // Add the appropriate number of spaces to the value.
                value = if (index == values.size - 1) {
                    val builder = StringBuilder()
                    for (i in 0 until diff) {
                        builder.append(" ")
                    }
                    builder.append(value)
                    builder.toString()
                } else {
                    value.padEnd(targetSpaceInRow, ' ')
                }

                // Add the formatted value to the list.
                finalArray.add(value)
            }

            // Print the formatted values.
            return finalArray.joinToString("")
        }
    }

}