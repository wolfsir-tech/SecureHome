package com.example.secure_home

import android.Manifest
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.widget.RemoteViews
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey

/**
 * Home-screen widget with Arm / Disarm buttons that send the GSM alarm command
 * by SMS in the background, without opening the app.
 *
 * The alarm phone number and SIM subscription are read from the same
 * EncryptedSharedPreferences store that flutter_secure_storage writes to, so
 * values changed inside the app are immediately visible here.
 */
class SecureHomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { id ->
            val views = buildViews(context)
            views.setOnClickPendingIntent(
                R.id.widget_arm_button,
                commandPendingIntent(context, ACTION_ARM, id),
            )
            views.setOnClickPendingIntent(
                R.id.widget_disarm_button,
                commandPendingIntent(context, ACTION_DISARM, id),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            ACTION_ARM -> sendAlarmCommand(context, isArm = true)
            ACTION_DISARM -> sendAlarmCommand(context, isArm = false)
        }
    }

    private fun buildViews(context: Context): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.secure_home_widget)
        val status = when (readStatus(context)) {
            STATUS_ARMED -> context.getString(R.string.widget_status_armed)
            STATUS_DISARMED -> context.getString(R.string.widget_status_disarmed)
            else -> context.getString(R.string.widget_status_unknown)
        }
        views.setTextViewText(R.id.widget_status, status)
        return views
    }

    private fun commandPendingIntent(context: Context, action: String, widgetId: Int): PendingIntent {
        val intent = Intent(context, SecureHomeWidgetProvider::class.java).apply {
            this.action = action
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        }
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        return PendingIntent.getBroadcast(context, widgetId, intent, flags)
    }

    private fun sendAlarmCommand(context: Context, isArm: Boolean) {
        val phone = readPhone(context)
        if (phone.isNullOrBlank()) {
            Toast.makeText(context, R.string.widget_no_phone, Toast.LENGTH_LONG).show()
            return
        }
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.SEND_SMS)
            != PackageManager.PERMISSION_GRANTED
        ) {
            Toast.makeText(context, R.string.widget_no_sms_permission, Toast.LENGTH_LONG).show()
            return
        }
        val command = if (isArm) COMMAND_ARM else COMMAND_DISARM
        try {
            val smsManager = smsManager(context)
            val parts = smsManager.divideMessage(command)
            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(phone, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(phone, null, command, null, null)
            }
            writeStatus(context, if (isArm) STATUS_ARMED else STATUS_DISARMED)
            Toast.makeText(
                context,
                if (isArm) R.string.widget_sent_arm else R.string.widget_sent_disarm,
                Toast.LENGTH_SHORT,
            ).show()
        } catch (error: Exception) {
            Toast.makeText(context, R.string.widget_send_failed, Toast.LENGTH_LONG).show()
        }
        // Refresh the displayed status.
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(
            android.content.ComponentName(context, SecureHomeWidgetProvider::class.java),
        )
        ids.forEach { id -> manager.updateAppWidget(id, buildViews(context)) }
    }

    private fun smsManager(context: Context): SmsManager {
        val base = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.getSystemService(SmsManager::class.java)
        } else {
            @Suppress("DEPRECATION")
            SmsManager.getDefault()
        }
        val subscriptionId = readSubscriptionId(context) ?: return base
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            base.createForSubscriptionId(subscriptionId)
        } else {
            @Suppress("DEPRECATION")
            SmsManager.getSmsManagerForSubscriptionId(subscriptionId)
        }
    }

    private fun encryptedPrefs(context: Context) = runCatching {
        EncryptedSharedPreferences.create(
            context,
            SECURE_PREFS_NAME,
            MasterKey.Builder(context)
                .setKeyGenParameterSpec(
                    android.security.keystore.KeyGenParameterSpec.Builder(
                        MasterKey.DEFAULT_MASTER_KEY_ALIAS,
                        android.security.keystore.KeyProperties.PURPOSE_ENCRYPT or
                            android.security.keystore.KeyProperties.PURPOSE_DECRYPT,
                    )
                        .setEncryptionPaddings(android.security.keystore.KeyProperties.ENCRYPTION_PADDING_NONE)
                        .setBlockModes(android.security.keystore.KeyProperties.BLOCK_MODE_GCM)
                        .setKeySize(256)
                        .build(),
                )
                .build(),
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
        )
    }.getOrNull()

    private fun read(context: Context, key: String): String? {
        val prefs = encryptedPrefs(context) ?: return null
        return prefs.getString("${KEY_PREFIX}_$key", null)
    }

    private fun write(context: Context, key: String, value: String) {
        encryptedPrefs(context)?.edit()?.putString("${KEY_PREFIX}_$key", value)?.apply()
    }

    private fun readPhone(context: Context): String? = read(context, KEY_ALARM_PHONE)

    private fun readSubscriptionId(context: Context): Int? =
        read(context, KEY_SMS_SUBSCRIPTION)?.toIntOrNull()

    private fun readStatus(context: Context): String? = read(context, KEY_LAST_STATUS)

    private fun writeStatus(context: Context, status: String) = write(context, KEY_LAST_STATUS, status)

    private companion object {
        const val ACTION_ARM = "com.securehome.app.widget.ARM"
        const val ACTION_DISARM = "com.securehome.app.widget.DISARM"

        // Must stay in sync with lib/core/constants/alarm_commands.dart
        const val COMMAND_ARM = "P123456P11"
        const val COMMAND_DISARM = "P123456P0"

        const val SECURE_PREFS_NAME = "FlutterSecureStorage"
        const val KEY_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIHNlY3VyZSBzdG9yYWdlCg"

        // Must stay in sync with lib/core/constants/storage_keys.dart
        const val KEY_ALARM_PHONE = "alarm_phone_e164"
        const val KEY_SMS_SUBSCRIPTION = "sms_subscription_id"
        const val KEY_LAST_STATUS = "last_alarm_status"

        const val STATUS_ARMED = "secured"
        const val STATUS_DISARMED = "disarmed"
    }
}
