package com.mc_downloader1
import android.content.ClipboardManager
import android.content.Intent
import android.util.Patterns

internal class ClipboardListener(private val context: MainActivity, private val manager: ClipboardManager) :
    ClipboardManager.OnPrimaryClipChangedListener {
    fun String.isValidUrl(): Boolean = Patterns.WEB_URL.matcher(this).matches()

    override fun onPrimaryClipChanged() {
        val item = manager.primaryClip!!.getItemAt(0)
        if(getToShow==true){
      var pastData1: CharSequence =  item.text
      
      //  val pattern = """(http|https)://[\w.-]+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?""".toRegex()
        if(pastData1.contains("twitter.com")||pastData1.contains("x.com")||pastData1.contains("tiktok.com")||pastData1.contains("vt.tiktok.com")||pastData1.contains("instagram.com")||
            pastData1.contains("facebook.com")||pastData1.contains("fb.watch")||pastData1.contains("playlist")||pastData1.contains("youtu.be")||pastData1.contains("youtube.com")
            ||pastData1.contains("m.youtube")){
            if (pastData1.toString().isValidUrl()) {
                pastData = item.text
            if (context.checkHasDrawOverlayPermissions()) {
                var intent= Intent(context, FloatingControlService::class.java)
                context.startService(intent)
            } else {
                context.navigateDrawPermissionSetting()
            }
        }else{
            //   Log.e("widget:", "is not url -----------------------------------------------------------------------")

        }
        }
        }
    }
}

