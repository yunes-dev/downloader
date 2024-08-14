package com.mc_downloader1

import android.annotation.SuppressLint
import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.util.DisplayMetrics
import android.util.Log
import android.view.*
import android.view.ViewGroup.LayoutParams
import android.widget.ImageView
import androidx.cardview.widget.CardView
import androidx.core.app.NotificationCompat
import com.mc_downloader1.MainActivity.Companion.ACTION_STOP_FOREGROUND
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import java.util.Timer
import java.util.TimerTask

var getToShow=false
class FloatingControlService : Service() {

    private var windowManager: WindowManager? = null
    private var floatingControlView: CardView? = null
    var iconHeight = 0
    var iconWidth = 0
    private var screenHeight = 0
    private var screenWidth = 0
    private var hideHandler: Handler? = null
    private var hideRunnable: Runnable? = null

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (windowManager == null) {
            windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        }
        if (floatingControlView == null) {
            createFloatingControlView()
        }
        if (intent?.action != null && intent.action.equals(
                ACTION_STOP_FOREGROUND, ignoreCase = true)) {
            removeFloatingControl()
            stopForeground(true)
            stopSelf()
        } else {
            generateForegroundNotification()
            addFloatingMenu()
        }
        timerClose()
        return START_STICKY
    }

    private fun createFloatingControlView() {
             floatingControlView = createCustomView()
    }

    fun timerClose() {
        val timer = Timer()
        var count = 0

        val task = object : TimerTask() {
            override fun run() {
                if (count == 5) {
                    removeFloatingControl()
                    stopForeground(true)
                    stopSelf()
                    println("is 5")
                    timer.cancel()  // Stop the timer when count reaches 5
                } else {
                    println("Current count: $count")
                    count++
                }
            }
        }

        val delay = 0L  // Initial delay
        val period = 1000L  // Timer interval in milliseconds (1 second)

        timer.scheduleAtFixedRate(task, delay, period)
    }
    private fun createCustomView(): CardView {

        val cardView = CardView(this)
        val cardViewLayoutParams =
            ViewGroup.LayoutParams(60.dp, 60.dp) // Adjust these values as needed
        cardView.layoutParams = cardViewLayoutParams
        cardView.radius = 40.dp.toFloat()
        cardView.setCardBackgroundColor(Color.WHITE) // Set your desired background color

        val imageView = ImageView(this)
        val imageViewLayoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        imageView.layoutParams = imageViewLayoutParams
        imageView.scaleType = ImageView.ScaleType.CENTER_CROP
        imageView.setImageResource(R.drawable.ic_alaram) // Set your image resource here
        // imageView.contentDescription = getString(R.string.story_image)
        cardView.addView(imageView)
        return  cardView
    }
    private val Int.dp: Int
        get() = (this * resources.displayMetrics.density).toInt()


    private fun removeFloatingControl() {
        if (floatingControlView?.parent != null) {
            windowManager?.removeView(floatingControlView)
        }
    }

    private fun addFloatingMenu() {
        if (floatingControlView?.parent == null) {
            // Set layout params to display the controls over any screen.
            val params = WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_PHONE
                else WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
            params.height = dpToPx(60)
            params.width = dpToPx(60)
            iconWidth = params.width
            iconHeight = params.height
            screenHeight = windowManager?.defaultDisplay?.height ?: 0
            screenWidth = windowManager?.defaultDisplay?.width ?: 0
            // Initial position of the floating controls
            params.gravity = Gravity.BOTTOM or Gravity.END
            params.x = 35
            params.y = 120
            // Add the custom view to the window manager
            windowManager?.addView(floatingControlView, params)
            try {
                addOnTouchListener(params)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
fun pushAndStart(){
getToShow=true
    val intent10 = Intent(this, MainActivity::class.java) // Replace YourActivity with the actual activity to start
    intent10.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    removeFloatingControl()
    stopForeground(true)
    stopSelf()
    startActivity(intent10)
}
    @SuppressLint("ClickableViewAccessibility")
    private fun addOnTouchListener(params: WindowManager.LayoutParams) {

        floatingControlView?.setOnTouchListener(object : View.OnTouchListener {
            private var initialTouchX = 0f
            private var initialTouchY = 0f
            private var initialX = 0
            private var initialY = 0

            @SuppressLint("ClickableViewAccessibility")
            override fun onTouch(view: View?, motionEvent: MotionEvent): Boolean {
                val flag3: Boolean
                flag3 = true
                var flag = false

                when (motionEvent.action) {

                    MotionEvent.ACTION_DOWN -> {
                        params.alpha = 1.0f
                        initialX = params.x
                        initialY = params.y
                        initialTouchX = motionEvent.rawX
                        initialTouchY = motionEvent.rawY

                        pushAndStart()

                        return true
                    }
                    MotionEvent.ACTION_UP -> {
                        flag = flag3
                        if (Math.abs(initialTouchX - motionEvent.rawX) >= 25f) {
                            return flag
                        } else {
                            flag = flag3
                            if (Math.abs(
                                    initialTouchY
                                            - motionEvent.rawY
                                ) >= 25f
                            ) {
                                return flag
                            } else {
                                return true
                            }
                        }
                    }
                    MotionEvent.ACTION_BUTTON_PRESS->{
                        Log.e("widget:", "widget is -----------------------------------------------------------------------")

                    }
                    MotionEvent.ACTION_HOVER_ENTER->{
                        Log.e("widget:", "widget is -----------------------------------------------------------------------")

                    }

                            MotionEvent.ACTION_MOVE -> {
                        initialX = params.x
                        initialY = params.y
                        if ((motionEvent.rawX < (initialX - iconWidth / 2).toFloat()) || (motionEvent.rawY < (initialY - iconHeight / 2).toFloat()) || (motionEvent.rawX
                                .toDouble() > initialX.toDouble() + iconWidth.toDouble() * 1.2)
                        ) {
                        }
                        params.x = (motionEvent.rawX - (iconWidth / 2).toFloat()).toInt()
                        params.y = (motionEvent.rawY - iconHeight.toFloat()).toInt()
                        try {
                            windowManager?.updateViewLayout(floatingControlView, params)
                        } catch (e: java.lang.Exception) {
                            e.printStackTrace()
                            return true
                        }
                        return true
                    }
                    else -> {
                    }
                }
                return flag
            }
        })
    }

    // Notification for ON-going
    private var iconNotification: Bitmap? = null
    private var notification: Notification? = null
    var mNotificationManager: NotificationManager? = null
    private val mNotificationId = 123

    private fun generateForegroundNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intentMainLanding = Intent(this, MainActivity::class.java)
            val pendingIntent =
                PendingIntent.getActivity(this, 0, intentMainLanding, PendingIntent.FLAG_IMMUTABLE)
            iconNotification = BitmapFactory.decodeResource(resources, R.mipmap.ic_launcher)
            if (mNotificationManager == null) {
                mNotificationManager =
                    this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                assert(mNotificationManager != null)
                mNotificationManager?.createNotificationChannelGroup(
                    NotificationChannelGroup("chats_group", "Chats")
                )
                val notificationChannel =
                    NotificationChannel("service_channel", "Service Notifications",
                        NotificationManager.IMPORTANCE_MIN)
                notificationChannel.enableLights(false)
                notificationChannel.lockscreenVisibility = Notification.VISIBILITY_SECRET
                mNotificationManager?.createNotificationChannel(notificationChannel)
            }
            val builder = NotificationCompat.Builder(this, "service_channel")

            builder.setContentTitle(
                StringBuilder("تم نسخ الرابط").append("")
                    .toString()
            )
                .setTicker(
                    StringBuilder(resources.getString(R.string.app_name)).append("service is running")
                        .toString()
                )
                .setContentText(pastData) //                    , swipe down for more options.
                .setSmallIcon(R.mipmap.ic_launcher)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setWhen(0)
                .setOnlyAlertOnce(true)
                .setContentIntent(pendingIntent)
                .setOngoing(true)
            if (iconNotification != null) {
                builder.setLargeIcon(Bitmap.createScaledBitmap(iconNotification!!, 128, 128, false))
            }
            builder.color = Color.BLUE
            notification = builder.build()
            startForeground(mNotificationId, notification)
        }
    }

    // Method to convert dp to px
    private fun dpToPx(dp: Int): Int {
        val displayMetrics = this.resources.displayMetrics
        return Math.round(dp * (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT))
    }
}
