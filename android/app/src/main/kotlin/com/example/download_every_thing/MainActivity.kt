package com.mc_downloader22
import io.flutter.embedding.android.FlutterActivity
import android.content.ClipboardManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
var pastData: CharSequence = ""

class MainActivity: FlutterActivity() {

     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
         GeneratedPluginRegistrant.registerWith(flutterEngine)
               val channelName = "clipboarding";
         val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
         channel.setMethodCallHandler { call, result ->
             if (call.method == "callKotlinMethod") {
                 result.success(pastData)
                 Log.e("pastData:", pastData.toString())
                 pastData=""
                     Log.e("erorr:", "error is -----------------------------------------------------------------------")
             }
                 else{
                 result.notImplemented()
             }

         }

             val clipboardManager = getSystemService(CLIPBOARD_SERVICE) as ClipboardManager
             clipboardManager.addPrimaryClipChangedListener(
                 ClipboardListener(
                     this,
                     clipboardManager
                 )
             )

}
    override fun onStart() {
        super.onStart()
        getToShow=false
        Log.e("widget:", "onStart -----------------------------------------------------------------------")
    }

    override fun onResume() {
        super.onResume()
        getToShow=false
        Log.e("widget:", "onResume -----------------------------------------------------------------------")
    }

    override fun onPause() {
        super.onPause()
        getToShow=true
        Log.e("widget:", "onPause -----------------------------------------------------------------------")
    }

    override fun onStop() {
        super.onStop()
        getToShow=true
        Log.e("widget:", "onStop -----------------------------------------------------------------------")
    }

    override fun onDestroy() {
        super.onDestroy()
        getToShow=true
        Log.e("widget:", "onDestroy -----------------------------------------------------------------------")
    }
fun navigateDrawPermissionSetting() {
    val intent1 = Intent(
        Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
        Uri.parse("package:$packageName"))
    startActivityForResult(intent1, REQUEST_CODE_DRAW_PREMISSION)
}

override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    if(requestCode == REQUEST_CODE_DRAW_PREMISSION){
        checkAndStartService()
    }
}

 fun checkAndStartService() {
    if(checkHasDrawOverlayPermissions()) {
        startService(Intent(this, FloatingControlService::class.java))
    }
}

 fun checkHasDrawOverlayPermissions(): Boolean {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        Settings.canDrawOverlays(this)
    }else{
        true
    }
}
companion object {
    const val ACTION_STOP_FOREGROUND = "com.mc_downloader22.stopfloating.service"
    const val REQUEST_CODE_DRAW_PREMISSION = 2
}

}

