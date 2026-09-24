package com.example.secure_home

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "sendSms" -> sendSms(call, result)
                    "getSimCards" -> getSimCards(result)
                    "isSmsCapable" -> result.success(isSmsCapable())
                    else -> result.notImplemented()
                }
            }
    }

    private fun sendSms(call: MethodCall, result: MethodChannel.Result) {
        val to = call.argument<String>("to")
        val message = call.argument<String>("message")
        if (to.isNullOrBlank() || message.isNullOrBlank()) {
            result.success(failure("invalid_number"))
            return
        }
        if (!hasPermission(Manifest.permission.SEND_SMS)) {
            result.success(failure("permission_denied"))
            return
        }
        if (!isSmsCapable()) {
            result.success(failure("no_service"))
            return
        }
        try {
            val smsManager = smsManagerFor(call.argument<Int>("subscriptionId"))
            val parts = smsManager.divideMessage(message)
            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(to, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(to, null, message, null, null)
            }
            result.success(mapOf("ok" to true))
        } catch (error: SecurityException) {
            result.success(failure("permission_denied", error.message))
        } catch (error: IllegalArgumentException) {
            result.success(failure("invalid_number", error.message))
        } catch (error: Exception) {
            result.success(failure("sms_failed", error.message))
        }
    }

    private fun getSimCards(result: MethodChannel.Result) {
        if (!hasPermission(Manifest.permission.READ_PHONE_STATE)) {
            result.error("permission_denied", "Phone permission is needed to choose a SIM card.", null)
            return
        }
        try {
            val subscriptionManager =
                getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val infos = subscriptionManager.activeSubscriptionInfoList.orEmpty()
            val canReadNumber = hasPermission(Manifest.permission.READ_PHONE_NUMBERS) ||
                hasPermission(Manifest.permission.READ_SMS)
            val cards = infos.map { info ->
                mapOf(
                    "subscriptionId" to info.subscriptionId,
                    "displayName" to info.displayName?.toString().orEmpty(),
                    "carrierName" to info.carrierName?.toString().orEmpty(),
                    "slotIndex" to info.simSlotIndex,
                    "number" to if (canReadNumber) info.number else null,
                )
            }
            result.success(cards)
        } catch (error: SecurityException) {
            result.error("permission_denied", error.message, null)
        } catch (error: Exception) {
            result.success(emptyList<Map<String, Any?>>())
        }
    }

    private fun isSmsCapable(): Boolean {
        if (!packageManager.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)) return false
        val telephony = getSystemService(TelephonyManager::class.java) ?: return false
        return telephony.simState == TelephonyManager.SIM_STATE_READY
    }

    private fun smsManagerFor(subscriptionId: Int?): SmsManager {
        val base = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            getSystemService(SmsManager::class.java)
        } else {
            @Suppress("DEPRECATION")
            SmsManager.getDefault()
        }
        if (subscriptionId == null || subscriptionId == SubscriptionManager.INVALID_SUBSCRIPTION_ID) {
            return base
        }
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            base.createForSubscriptionId(subscriptionId)
        } else {
            @Suppress("DEPRECATION")
            SmsManager.getSmsManagerForSubscriptionId(subscriptionId)
        }
    }

    private fun hasPermission(permission: String): Boolean {
        return ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED
    }

    private fun failure(code: String, message: String? = null): Map<String, Any?> {
        return mapOf("ok" to false, "code" to code, "message" to message)
    }

    companion object {
        private const val CHANNEL = "com.securehome.app/device"
    }
}
