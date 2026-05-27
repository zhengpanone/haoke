package com.example.haoke_rent

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.haoke_rent/image_picker"
    private val pickImageRequestCode = 9101
    private val pickMultiImageRequestCode = 9102

    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (pendingResult != null) {
                result.error("IN_PROGRESS", "An image picking request is already running.", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "pickImage" -> {
                    pendingResult = result
                    launchPickImageIntent(multi = false)
                }

                "pickMultiImage" -> {
                    pendingResult = result
                    launchPickImageIntent(multi = true)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun launchPickImageIntent(multi: Boolean) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "image/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, multi)
        }

        startActivityForResult(
            intent,
            if (multi) pickMultiImageRequestCode else pickImageRequestCode
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        val result = pendingResult ?: return

        when (requestCode) {
            pickImageRequestCode -> {
                pendingResult = null
                if (resultCode != Activity.RESULT_OK || data == null) {
                    result.success(null)
                    return
                }

                val uri = data.data
                if (uri == null) {
                    result.success(null)
                    return
                }

                result.success(copyUriToCache(uri))
            }

            pickMultiImageRequestCode -> {
                pendingResult = null
                if (resultCode != Activity.RESULT_OK || data == null) {
                    result.success(emptyList<String>())
                    return
                }

                val files = mutableListOf<String>()

                data.data?.let { uri ->
                    copyUriToCache(uri)?.let { files.add(it) }
                }

                val clipData = data.clipData
                if (clipData != null) {
                    for (i in 0 until clipData.itemCount) {
                        val uri = clipData.getItemAt(i).uri
                        copyUriToCache(uri)?.let { files.add(it) }
                    }
                }

                result.success(files)
            }
        }
    }

    private fun copyUriToCache(uri: Uri): String? {
        return try {
            val extension = contentResolver.getType(uri)
                ?.substringAfterLast('/', "jpg")
                ?.ifBlank { "jpg" }
                ?: "jpg"
            val outputFile = File(cacheDir, "picked_${System.currentTimeMillis()}.$extension")
            contentResolver.openInputStream(uri)?.use { input ->
                FileOutputStream(outputFile).use { output ->
                    input.copyTo(output)
                }
            }
            outputFile.absolutePath
        } catch (_: Exception) {
            null
        }
    }
}
