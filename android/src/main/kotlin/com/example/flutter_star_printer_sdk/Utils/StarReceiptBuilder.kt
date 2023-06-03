package com.example.flutter_star_printer_sdk.Utils

import android.graphics.BitmapFactory
import com.starmicronics.stario10.starxpandcommand.*
import com.starmicronics.stario10.starxpandcommand.drawer.Channel
import com.starmicronics.stario10.starxpandcommand.drawer.OpenParameter
import com.starmicronics.stario10.starxpandcommand.printer.*
import io.flutter.Log

class StarReceiptBuilder {
    companion object {
        fun buildReceipt(contents: Collection<*>): StarXpandCommandBuilder {
            val builder = StarXpandCommandBuilder();
            val docBuilder = DocumentBuilder();

            for (content in contents) {
                if (content !is Map<*, *>) continue;
                val type = content["type"] as String
                val data = content["data"] as Map<*, *>

                when (type) {
                    "drawer" -> docBuilder.addDrawer(getDrawerBuilder(data))
                    "print" -> docBuilder.addPrinter(getPrinterBuilder(data))
                }
            }

            builder.addDocument(docBuilder);
            return builder;
        }


        private fun getDrawerBuilder(data: Map<*, *>): DrawerBuilder {
            val channel = when (data["channel"]) {
                "no1" -> Channel.No1
                "no2" -> Channel.No2
                else -> Channel.No1
            }
            return DrawerBuilder().actionOpen(OpenParameter().setChannel(channel))
        }

        private fun getPrinterBuilder(data: Map<*, *>): PrinterBuilder {
            val printerBuilder = PrinterBuilder()

            val actions = data["actions"] as Collection<*>

            Log.d("print", "print actions: $actions")

            for (action in actions) {
                if (action !is Map<*, *>) continue

                when (action["action"] as String) {
                    "add" -> {
                        printerBuilder.add(getPrinterBuilder(action["data"] as Map<*, *>))
                    }
                    "style" -> {
                        if (action["alignment"] != null) {
                            printerBuilder.styleAlignment(
                                when (action["alignment"]) {
                                    "left" -> Alignment.Left
                                    "center" -> Alignment.Center
                                    "right" -> Alignment.Right
                                    else -> Alignment.Left
                                }
                            )
                        }

                        if (action["fontType"] != null) {
                            printerBuilder.styleFont(
                                when (action["fontType"]) {
                                    "a" -> FontType.A
                                    "b" -> FontType.B
                                    else -> FontType.A
                                }
                            )
                        }

                        if (action["bold"] != null) {
                            printerBuilder.styleBold(action["bold"] as Boolean)
                        }

                        if (action["invert"] != null) {
                            printerBuilder.styleInvert(action["invert"] as Boolean)
                        }

                        if (action["underLine"] != null) {
                            printerBuilder.styleUnderLine(action["underLine"] as Boolean)
                        }

                        if (action["magnification"] != null) {
                            val magnification = action["magnification"] as Map<*, *>

                            printerBuilder.styleMagnification(
                                MagnificationParameter(
                                    magnification["width"] as Int,
                                    magnification["height"] as Int
                                )
                            )
                        }

                        if (action["characterSpace"] != null) {
                            printerBuilder.styleCharacterSpace(action["characterSpace"] as Double)
                        }

                        if (action["lineSpace"] != null) {
                            printerBuilder.styleLineSpace(action["lineSpace"] as Double)
                        }

                        if (action["horizontalPositionTo"] != null) {
                            printerBuilder.styleHorizontalPositionTo(action["horizontalPositionTo"] as Double)
                        }

                        if (action["horizontalPositionBy"] != null) {
                            printerBuilder.styleHorizontalPositionBy(action["horizontalPositionBy"] as Double)
                        }

                        if (action["horizontalTabPosition"] != null) {
                            printerBuilder.styleHorizontalTabPositions((action["horizontalTabPosition"] as List<*>).map { it as Int })
                        }

                        if (action["internationalCharacter"] != null) {
                            printerBuilder.styleInternationalCharacter(
                                when (action["internationalCharacter"]) {
                                    "usa" -> InternationalCharacterType.Usa
                                    "france" -> InternationalCharacterType.France
                                    "germany" -> InternationalCharacterType.Germany
                                    "uk" -> InternationalCharacterType.UK
                                    "denmark" -> InternationalCharacterType.Denmark
                                    "sweden" -> InternationalCharacterType.Sweden
                                    "italy" -> InternationalCharacterType.Italy
                                    "spain" -> InternationalCharacterType.Spain
                                    "japan" -> InternationalCharacterType.Japan
                                    "norway" -> InternationalCharacterType.Norway
                                    "denmark2" -> InternationalCharacterType.Denmark2
                                    "spain2" -> InternationalCharacterType.Spain2
                                    "latinAmerica" -> InternationalCharacterType.LatinAmerica
                                    "korea" -> InternationalCharacterType.Korea
                                    "ireland" -> InternationalCharacterType.Ireland
                                    "slovenia" -> InternationalCharacterType.Slovenia
                                    "croatia" -> InternationalCharacterType.Croatia
                                    "china" -> InternationalCharacterType.China
                                    "vietnam" -> InternationalCharacterType.Vietnam
                                    "arabic" -> InternationalCharacterType.Arabic
                                    "legal" -> InternationalCharacterType.Legal
                                    else -> InternationalCharacterType.Usa
                                }
                            )
                        }

                        if (action["secondPriorityCharacterEncoding"] != null) {
                            printerBuilder.styleSecondPriorityCharacterEncoding(
                                when (data["secondPriorityCharacterEncoding"]) {
                                    "japanese" -> CharacterEncodingType.Japanese
                                    "simplifiedChinese" -> CharacterEncodingType.SimplifiedChinese
                                    "traditionalChinese" -> CharacterEncodingType.TraditionalChinese
                                    "korean" -> CharacterEncodingType.Korean
                                    "codePage" -> CharacterEncodingType.CodePage
                                    else -> CharacterEncodingType.CodePage
                                }
                            )
                        }

                        if (action["cjkCharacterPriority"] != null) {
                            printerBuilder.styleCjkCharacterPriority((action["cjkCharacterPriority"] as List<*>).map {
                                when (it as String?) {
                                    "japanese" -> CjkCharacterType.Japanese
                                    "simplifiedChinese" -> CjkCharacterType.SimplifiedChinese
                                    "traditionalChinese" -> CjkCharacterType.TraditionalChinese
                                    "korean" -> CjkCharacterType.Korean
                                    else -> CjkCharacterType.Japanese
                                }
                            })
                        }
                    }
                    "cut" -> {
                        val cutType = when (action["type"]) {
                            "full" -> CutType.Full
                            "partial" -> CutType.Partial
                            "fullDirect" -> CutType.FullDirect
                            "partialDirect" -> CutType.PartialDirect
                            else -> CutType.Partial
                        }
                        printerBuilder.actionCut(cutType)
                    }
                    "feed" -> {
                        val height = (action["height"] as Double?) ?: 10.0
                        printerBuilder.actionFeed(height)
                    }
                    "feedLine" -> {
                        val lines = (action["lines"] as Int?) ?: 1
                        printerBuilder.actionFeedLine(lines)
                    }
                    "printRuledLine" -> {
                        val width = action["width"] as? Double
                        val thickness = action["thickness"] as? Double

                        val style = when (action["style"] as? String) {
                            "single" -> LineStyle.Single
                            "double" -> LineStyle.Double
                            else -> null
                        }

                        if (width != null && thickness != null && style != null) {
                            val ruledLineParameter = RuledLineParameter(width)
                                .setThickness(thickness)
                                .setLineStyle(style)

                            printerBuilder.actionPrintRuledLine(ruledLineParameter)
                        }

                    }
                    "printText" -> {
                        val text = action["text"] as String
                        printerBuilder.actionPrintText(text)
                    }
                    "printLeftAndRight" -> {
                        printerBuilder.actionPrintText("\n");

                        val texts = action["texts"] as List<*>
                        val maxPaperSize = action["maxPaperSize"] as Int
                        val stringTexts = texts.mapNotNull { it as? String }

                        printerBuilder.actionPrintText(
                            Utils.convertToFixedLengthString(
                                stringTexts,
                                maxPaperSize
                            )
                        )
                    }
                    "printRowText" -> {
                        printerBuilder.actionPrintText("\n");

                        val ratios = action["ratios"] as List<*>
                        val texts = action["texts"] as List<*>
                        val maxPaperSize = action["maxPaperSize"] as Int

                        val parsedRatios = ratios.mapNotNull { it as? Int }
                        val parsedTexts = texts.mapNotNull { it as? String }

                        printerBuilder.actionPrintText(
                            Utils.convertStringToFixedLengthRows(
                                parsedRatios,
                                parsedTexts,
                                maxPaperSize
                            )
                        )
                    }
                    "printLogo" -> {
                        val keyCode = action["keyCode"] as String
                        printerBuilder.actionPrintLogo(LogoParameter(keyCode))
                    }
                    "printBarcode" -> {
                        val barcodeContent = action["content"] as String
                        val symbology = when (action["symbology"] as String) {
                            "upcE" -> BarcodeSymbology.UpcE
                            "upcA" -> BarcodeSymbology.UpcA
                            "jan8" -> BarcodeSymbology.Jan8
                            "ean8" -> BarcodeSymbology.Ean8
                            "jan13" -> BarcodeSymbology.Jan13
                            "ean13" -> BarcodeSymbology.Ean13
                            "code39" -> BarcodeSymbology.Code39
                            "itf" -> BarcodeSymbology.Itf
                            "code128" -> BarcodeSymbology.Code128
                            "code93" -> BarcodeSymbology.Code93
                            "nw7" -> BarcodeSymbology.NW7
                            else -> BarcodeSymbology.UpcE
                        }

                        val param = BarcodeParameter(barcodeContent, symbology)
                        if (action["printHri"] != null) {
                            param.setPrintHri(action["printHri"] as Boolean)
                        }
                        if (action["barDots"] != null) {
                            param.setBarDots(action["barDots"] as Int)
                        }
                        if (action["barRatioLevel"] != null) {
                            param.setBarRatioLevel(
                                when (action["barRatioLevel"] as String) {
                                    "levelPlus1" -> BarcodeBarRatioLevel.LevelPlus1
                                    "level0" -> BarcodeBarRatioLevel.Level0
                                    "levelMinus1" -> BarcodeBarRatioLevel.LevelMinus1
                                    else -> BarcodeBarRatioLevel.Level0
                                }
                            )
                        }
                        if (action["height"] != null) {
                            param.setHeight(action["height"] as Double)
                        }

                        printerBuilder.actionPrintBarcode(param)
                    }
                    "printPdf417" -> {
                        val pdf417Content = action["content"] as String
                        val param = Pdf417Parameter(pdf417Content)

                        if (action["column"] != null) {
                            param.setColumn(action["column"] as Int)
                        }
                        if (action["line"] != null) {
                            param.setLine(action["line"] as Int)
                        }
                        if (action["module"] != null) {
                            param.setModule(action["module"] as Int)
                        }
                        if (action["aspect"] != null) {
                            param.setAspect(action["aspect"] as Int)
                        }
                        if (action["level"] != null) {
                            param.setLevel(
                                when (action["level"] as String) {
                                    "ecc0" -> Pdf417Level.Ecc0
                                    "ecc1" -> Pdf417Level.Ecc1
                                    "ecc2" -> Pdf417Level.Ecc2
                                    "ecc3" -> Pdf417Level.Ecc3
                                    "ecc4" -> Pdf417Level.Ecc4
                                    "ecc5" -> Pdf417Level.Ecc5
                                    "ecc6" -> Pdf417Level.Ecc6
                                    "ecc7" -> Pdf417Level.Ecc7
                                    "ecc8" -> Pdf417Level.Ecc8
                                    else -> Pdf417Level.Ecc0
                                }
                            )
                        }

                        printerBuilder.actionPrintPdf417(param)
                    }
                    "printQRCode" -> {
                        val qrContent = action["content"] as String
                        val param = QRCodeParameter(qrContent)

                        if (action["model"] != null) {
                            param.setModel(
                                when (action["model"] as String) {
                                    "model1" -> QRCodeModel.Model1
                                    "model2" -> QRCodeModel.Model2
                                    else -> QRCodeModel.Model1
                                }
                            )
                        }
                        if (action["level"] != null) {
                            param.setLevel(
                                when (action["level"] as String) {
                                    "l" -> QRCodeLevel.L
                                    "m" -> QRCodeLevel.M
                                    "q" -> QRCodeLevel.Q
                                    "h" -> QRCodeLevel.H
                                    else -> QRCodeLevel.L
                                }
                            )
                        }
                        if (action["cellSize"] != null) {
                            param.setCellSize(action["cellSize"] as Int)
                        }

                        printerBuilder.actionPrintQRCode(param)
                    }
                    "printImage" -> {
                        val image = action["image"] as ByteArray
                        val width = action["width"] as Int
                        val bmp = BitmapFactory.decodeByteArray(image, 0, image.size)
                        printerBuilder.actionPrintImage(ImageParameter(bmp, width))
                    }
                }
            }
            return printerBuilder
        }

    }


}

