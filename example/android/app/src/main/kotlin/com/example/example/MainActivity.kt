package com.example.example

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugins.GeneratedPluginRegistrant
import vn.educa.bridge.Pigeon
import java.io.FileOutputStream
import java.util.logging.StreamHandler

class MainActivity : FlutterActivity() {
    companion object {
        const val TAG = "MainActivity"
    }

    private var mEventPhoto: EventSink? = null

    inner class AndroidAPI(private var context: Context) : Pigeon.ReqApi {
        override fun request(request: Pigeon.Req): Pigeon.Res {
            if (request.key == "keyOpenSearch") {
                startWebAct(request.data)
            } else if (request.key == "keyOpenPhoto") {
                showDialogPhoto()
            }
            val res = Pigeon.Res()
            res.key = "KEY_COMMON_RES"
            val rs = HashMap<Any, String>()
            rs["result"] = "true"
            res.data = rs as Map<Any, Any>?
            return res
        }

        private fun startWebAct(data: Map<Any, Any>?) {
            val link: String = data?.get("url") as String
            Log.i(TAG, "link: $link")
            val intent = Intent()
            intent.data = Uri.parse(link)
            intent.action = Intent.ACTION_VIEW
            startActivity(intent)
        }
    }

    private fun showDialogPhoto() {
        openCamera()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        for (i in grantResults) {
            if (i != PackageManager.PERMISSION_GRANTED)
                return
        }
        if (requestCode == 103) {
            openCamera()
        }
    }

    private fun openCamera() {
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        startActivityForResult(intent, 103)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        try {
            val photo = data!!.extras!!["data"] as Bitmap?
            val fileName =
                Environment.getDataDirectory().path + "/data/" + packageName + "/avatar.jpg"
            FileOutputStream(fileName).use { out ->
                photo!!.compress(
                    Bitmap.CompressFormat.JPEG, 90, out
                ) // bmp is your Bitmap instance
            }
            Log.i("onActivityResult", "uri: $fileName")
            mEventPhoto?.success(fileName)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(flutterEngine!!)
        Pigeon.ReqApi.setup(
            flutterEngine?.dartExecutor?.binaryMessenger,
            AndroidAPI(this)
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        EventChannel(flutterEngine.dartExecutor, "bridgeStream").setStreamHandler(
            object : StreamHandler(), EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventSink?) {
                    mEventPhoto = events
                }

                override fun onCancel(arguments: Any?) {
                }
            }
        )
    }
}
