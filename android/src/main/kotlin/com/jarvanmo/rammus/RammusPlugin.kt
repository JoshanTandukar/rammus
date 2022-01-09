package com.jarvanmo.rammus

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.alibaba.sdk.android.push.CommonCallback
import com.alibaba.sdk.android.push.huawei.HuaWeiRegister
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import com.alibaba.sdk.android.push.register.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.Result

class RammusPlugin: FlutterPlugin, ActivityAware {

    private lateinit var methodChannel: MethodChannel

    private lateinit var initCloudChannel: EventChannel

    private lateinit var handleNotificationChannel: EventChannel

    private lateinit var callOutGoingChannel: EventChannel

    private lateinit var callIncomingChannel: EventChannel

    companion object
    {
        @JvmStatic
        lateinit var instance: RammusPlugin

        @JvmStatic
        lateinit var messenger: BinaryMessenger

        @JvmStatic
        lateinit var applicationContext: Context

        private const val TAG = "RammusPlugin"

        var initCloudSink: EventChannel.EventSink? = null

        var handleNotificationSink: EventChannel.EventSink? = null

        var callOutGoingSink: EventChannel.EventSink? = null

        var callIncomingSink: EventChannel.EventSink? = null

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar)
        {
            instance = RammusPlugin()
            instance.onAttachedToEngine(registrar.context(), registrar.messenger())
        }

        @JvmStatic
        fun initPushService(result: Result)
        {
            PushServiceFactory.init(applicationContext)
            val pushService = PushServiceFactory.getCloudPushService()
            pushService.register(applicationContext, object : CommonCallback
            {
                override fun onSuccess(response: String?)
                {
                    instance.sendInitCloudEvent(
                        "initCloudChannel",
                        mapOf(
                            "isSuccessful" to true,
                            "response" to response,
                            "errorCode" to null,
                            "errorMessage" to null
                        )
                    )
                    result.success(
                        mapOf(
                            "isSuccessful" to true,
                            "response" to response,
                            "errorCode" to null,
                            "errorMessage" to null
                        ),
                    )
                }

                override fun onFailed(errorCode: String?, errorMessage: String?)
                {
                    instance.sendInitCloudEvent(
                        "initCloudChannel",
                        mapOf(
                            "isSuccessful" to false,
                            "response" to null,
                            "errorCode" to errorCode,
                            "errorMessage" to errorMessage
                        ),
                    )
                    result.success(
                        mapOf(
                            "isSuccessful" to false,
                            "response" to null,
                            "errorCode" to errorCode,
                            "errorMessage" to errorMessage
                        ),
                    )
                }
            })
            pushService.setPushIntentService(RammusPushIntentService::class.java)
            val appInfo = applicationContext.packageManager
                .getApplicationInfo(applicationContext.packageName, PackageManager.GET_META_DATA)
            val xiaomiAppId = appInfo.metaData.getString("com.xiaomi.push.client.app_id")
            val xiaomiAppKey = appInfo.metaData.getString("com.xiaomi.push.client.app_key")
            if ((xiaomiAppId != null && xiaomiAppId.isNotBlank())
                && (xiaomiAppKey != null && xiaomiAppKey.isNotBlank())){
                Log.d(TAG, "正在注册小米推送服务...")
                MiPushRegister.register(applicationContext, xiaomiAppId, xiaomiAppKey)
            }
            val huaweiAppId = appInfo.metaData.getString("com.huawei.hms.client.appid")
            if (huaweiAppId != null && huaweiAppId.toString().isNotBlank()){
                Log.d(TAG, "正在注册华为推送服务...")
                HuaWeiRegister.register(Application())
            }
            val oppoAppKey = appInfo.metaData.getString("com.oppo.push.client.app_key")
            val oppoAppSecret = appInfo.metaData.getString("com.oppo.push.client.app_secret")
            if ((oppoAppKey != null && oppoAppKey.isNotBlank())
                && (oppoAppSecret != null && oppoAppSecret.isNotBlank())){
                Log.d(TAG, "正在注册Oppo推送服务...")
                OppoRegister.register(applicationContext, oppoAppKey, oppoAppSecret)
            }
            val meizuAppId = appInfo.metaData.getString("com.meizu.push.client.app_id")
            val meizuAppKey = appInfo.metaData.getString("com.meizu.push.client.app_key")
            if ((meizuAppId != null && meizuAppId.isNotBlank())
                && (meizuAppKey != null && meizuAppKey.isNotBlank())){
                Log.d(TAG, "正在注册魅族推送服务...")
                MeizuRegister.register(applicationContext, meizuAppId, meizuAppKey)
            }
            val vivoAppId = appInfo.metaData.getString("com.vivo.push.app_id")
            val vivoApiKey = appInfo.metaData.getString("com.vivo.push.api_key")
            if ((vivoAppId != null && vivoAppId.isNotBlank())
                && (vivoApiKey != null && vivoApiKey.isNotBlank())){
                Log.d(TAG, "正在注册Vivo推送服务...")
                VivoRegister.register(applicationContext)
            }
            val gcmSendId = appInfo.metaData.getString("com.gcm.push.send_id")
            val gcmApplicationId = appInfo.metaData.getString("com.gcm.push.app_id")
            if ((gcmSendId != null && gcmSendId.isNotBlank())
                && (gcmApplicationId != null && gcmApplicationId.isNotBlank())){
                Log.d(TAG, "正在注册Gcm推送服务...")
                GcmRegister.register(applicationContext, gcmSendId, gcmApplicationId)
            }
        }

        @JvmStatic
        fun onNotification(title:String, summary:String, extras:Map<String, String>)
        {
            Log.d("RammusPlugin","onNotification title is $title, summary is $summary, extras: $extras")
            instance.sendNotification(
                    "onNotification",
                    mapOf(
                            "title" to title,
                            "summary" to summary,
                            "extras" to extras,
                    )
            )
        }

        @JvmStatic
        fun onMessage(title:String, content:String, appId:String, messageId:String, traceInfo:String)
        {
            Log.d("RammusPlugin","onMessage title is $title, messageId is $messageId, content is $content, appId is $appId, traceInfo is $traceInfo")

            instance.sendNotification(
                    "onMessage",
                    mapOf(
                            "title" to title,
                            "content" to content,
                            "appId" to appId,
                            "messageId" to messageId,
                            "traceInfo" to traceInfo,
                    )
            )
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger)
    {
        RammusPlugin.messenger = messenger
        RammusPlugin.applicationContext = applicationContext

        val pluginHandler = RammusPluginHandler()

        methodChannel = MethodChannel(messenger, "Rammus")
        methodChannel.setMethodCallHandler(pluginHandler)

        initCloudChannel = EventChannel(messenger, "Rammus/initCloudChannel")

        initCloudChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                Log.d(TAG, "onListen: RammusPlugin.onAttachedToEngine => Notification eventChannel attached ")
                initCloudSink = events
            }

            override fun onCancel(arguments: Any) {
                Log.d(TAG, "onCancel: RammusPlugin.onAttachedToEngine => Notification eventChannel detached ")
                initCloudSink = null
            }
        })

        handleNotificationChannel = EventChannel(messenger, "Rammus/notificationChannel")
        handleNotificationChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                Log.d(TAG, "onListen: RammusPlugin.onAttachedToEngine => handleMessage eventChannel attached")
                handleNotificationSink = events
            }

            override fun onCancel(arguments: Any) {
                Log.d(TAG, "onCancel: RammusPlugin.onAttachedToEngine => handleMessage eventChannel detached")
                handleNotificationSink = null
            }
        })

        callOutGoingChannel = EventChannel(messenger, "TwilioVoice/callOutGoingChannel")
        callOutGoingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                Log.d(TAG, "onListen: TwilioVoice.onAttachedToEngine => onCallChannel eventChannel attached")
                callOutGoingSink = events
            }

            override fun onCancel(arguments: Any) {
                Log.d(TAG, "onCancel: TwilioVoice.onAttachedToEngine => onCallChannel eventChannel detached")
                callOutGoingSink = null
            }
        })

        callIncomingChannel = EventChannel(messenger, "TwilioVoice/callIncomingChannel")
        callIncomingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                Log.d(TAG, "onListen: TwilioVoice.onAttachedToEngine => onCallChannel eventChannel attached")
                callIncomingSink = events
            }

            override fun onCancel(arguments: Any) {
                Log.d(TAG, "onCancel: TwilioVoice.onAttachedToEngine => onCallChannel eventChannel detached")
                callIncomingSink = null
            }
        })
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine: TwilioVoice.onDetachedFromEngine")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding)
    {
        applicationContext=binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges()
    {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges: TwilioVoice.onDetachedFromActivityForConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        applicationContext=binding.activity
    }

    override fun onDetachedFromActivity()
    {
        Log.d(TAG, "onDetachedFromActivity: TwilioVoice.onDetachedFromActivity")
    }

//    fun initPushService(result: Result)
//    {
//        PushServiceFactory.init(applicationContext)
//        val pushService = PushServiceFactory.getCloudPushService()
//        pushService.register(applicationContext, object : CommonCallback
//        {
//            override fun onSuccess(response: String?)
//            {
//                sendInitCloudEvent(
//                        "initCloudChannel",
//                        mapOf(
//                                "isSuccessful" to true,
//                                "response" to response,
//                                "errorCode" to null,
//                                "errorMessage" to null
//                        )
//                )
//                result.success(
//                        mapOf(
//                                "isSuccessful" to true,
//                                "response" to response,
//                                "errorCode" to null,
//                                "errorMessage" to null
//                        ),
//                )
//            }
//
//            override fun onFailed(errorCode: String?, errorMessage: String?)
//            {
//                sendInitCloudEvent(
//                        "initCloudChannel",
//                        mapOf(
//                                "isSuccessful" to false,
//                                "response" to null,
//                                "errorCode" to errorCode,
//                                "errorMessage" to errorMessage
//                        ),
//                )
//                result.success(
//                        mapOf(
//                                "isSuccessful" to false,
//                                "response" to null,
//                                "errorCode" to errorCode,
//                                "errorMessage" to errorMessage
//                        ),
//                )
//            }
//        })
//        pushService.setPushIntentService(RammusPushIntentService::class.java)
//        val appInfo = applicationContext.packageManager
//                .getApplicationInfo(applicationContext.packageName, PackageManager.GET_META_DATA)
//        val xiaomiAppId = appInfo.metaData.getString("com.xiaomi.push.client.app_id")
//        val xiaomiAppKey = appInfo.metaData.getString("com.xiaomi.push.client.app_key")
//        if ((xiaomiAppId != null && xiaomiAppId.isNotBlank())
//                && (xiaomiAppKey != null && xiaomiAppKey.isNotBlank())){
//            Log.d(TAG, "正在注册小米推送服务...")
//            MiPushRegister.register(applicationContext, xiaomiAppId, xiaomiAppKey)
//        }
//        val huaweiAppId = appInfo.metaData.getString("com.huawei.hms.client.appid")
//        if (huaweiAppId != null && huaweiAppId.toString().isNotBlank()){
//            Log.d(TAG, "正在注册华为推送服务...")
//            HuaWeiRegister.register(Application())
//        }
//        val oppoAppKey = appInfo.metaData.getString("com.oppo.push.client.app_key")
//        val oppoAppSecret = appInfo.metaData.getString("com.oppo.push.client.app_secret")
//        if ((oppoAppKey != null && oppoAppKey.isNotBlank())
//                && (oppoAppSecret != null && oppoAppSecret.isNotBlank())){
//            Log.d(TAG, "正在注册Oppo推送服务...")
//            OppoRegister.register(applicationContext, oppoAppKey, oppoAppSecret)
//        }
//        val meizuAppId = appInfo.metaData.getString("com.meizu.push.client.app_id")
//        val meizuAppKey = appInfo.metaData.getString("com.meizu.push.client.app_key")
//        if ((meizuAppId != null && meizuAppId.isNotBlank())
//                && (meizuAppKey != null && meizuAppKey.isNotBlank())){
//            Log.d(TAG, "正在注册魅族推送服务...")
//            MeizuRegister.register(applicationContext, meizuAppId, meizuAppKey)
//        }
//        val vivoAppId = appInfo.metaData.getString("com.vivo.push.app_id")
//        val vivoApiKey = appInfo.metaData.getString("com.vivo.push.api_key")
//        if ((vivoAppId != null && vivoAppId.isNotBlank())
//                && (vivoApiKey != null && vivoApiKey.isNotBlank())){
//            Log.d(TAG, "正在注册Vivo推送服务...")
//            VivoRegister.register(applicationContext)
//        }
//        val gcmSendId = appInfo.metaData.getString("com.gcm.push.send_id")
//        val gcmApplicationId = appInfo.metaData.getString("com.gcm.push.app_id")
//        if ((gcmSendId != null && gcmSendId.isNotBlank())
//                && (gcmApplicationId != null && gcmApplicationId.isNotBlank())){
//            Log.d(TAG, "正在注册Gcm推送服务...")
//            GcmRegister.register(applicationContext, gcmSendId, gcmApplicationId)
//        }
//    }

    fun turnOnPushChannel(result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.turnOnPushChannel(object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }

    fun turnOffPushChannel(result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.turnOffPushChannel(object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun checkPushChannelStatus(result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.checkPushChannelStatus(object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun bindAccount(call: MethodCall, result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.bindAccount(call.arguments as String?, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun unbindAccount(result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.unbindAccount(object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }

    //bindPhoneNumber


    fun bindPhoneNumber(call: MethodCall, result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.bindPhoneNumber(call.arguments as String?, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun unbindPhoneNumber(result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.unbindPhoneNumber(object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun bindTag(call: MethodCall, result: Result) {
//        target: Int, tags: Array<String>, alias: String, callback: CommonCallback
        val target = call.argument("target") ?: 1
        val tagsInArrayList = call.argument("tags") ?: arrayListOf<String>()
        val alias = call.argument<String?>("alias")

        val arr = arrayOfNulls<String>(tagsInArrayList.size)
        val tags: Array<String> = tagsInArrayList.toArray(arr)

        val pushService = PushServiceFactory.getCloudPushService()

        pushService.bindTag(target, tags, alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun unbindTag(call: MethodCall, result: Result) {
//        target: Int, tags: Array<String>, alias: String, callback: CommonCallback
        val target = call.argument("target") ?: 1
        val tagsInArrayList = call.argument("tags") ?: arrayListOf<String>()
        val alias = call.argument<String?>("alias")

        val arr = arrayOfNulls<String>(tagsInArrayList.size)
        val tags: Array<String> = tagsInArrayList.toArray(arr)

        val pushService = PushServiceFactory.getCloudPushService()

        pushService.unbindTag(target, tags, alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }

    fun listTags(call: MethodCall, result: Result) {
        val target = call.arguments as Int? ?: 1
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.listTags(target, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }


    fun addAlias(call: MethodCall, result: Result) {
        val alias = call.arguments as String?
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.addAlias(alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }

    fun removeAlias(call: MethodCall, result: Result) {
        val alias = call.arguments as String?
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.removeAlias(alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }

    fun listAliases(result: Result) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.listAliases(object : CommonCallback {
            override fun onSuccess(response: String?) {
                result.success(mapOf(
                        "isSuccessful" to true,
                        "response" to response
                ))

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                result.success(mapOf(
                        "isSuccessful" to false,
                        "errorCode" to errorCode,
                        "errorMessage" to errorMessage
                ))
            }
        })
    }

    @Suppress("UNCHECKED_CAST")
    fun setupNotificationManager(call: MethodCall, result: Result)
    {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            val channels = call.arguments as List<Map<String, Any?>>
            val mNotificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val notificationChannels = mutableListOf<NotificationChannel>()
            for (channel in channels)
            {
                // 通知渠道的id
                val id = channel["id"] ?: applicationContext.packageName
                // 用户可以看到的通知渠道的名字.
                val name = channel["name"] ?: applicationContext.packageName
                // 用户可以看到的通知渠道的描述
                val description = channel["description"] ?: applicationContext.packageName
                val importance = channel["importance"] ?: NotificationManager.IMPORTANCE_DEFAULT
                val mChannel = NotificationChannel(id as String, name as String, importance as Int)
                // 配置通知渠道的属性
                mChannel.description = description as String
                mChannel.enableLights(true)
                mChannel.enableVibration(true)
                notificationChannels.add(mChannel)
            }
            if (notificationChannels.isNotEmpty())
            {
                mNotificationManager.createNotificationChannels(notificationChannels)
            }
        }
        result.success(
                mapOf(
                        "isSuccessful" to true,
                        "response" to null,
                        "errorCode" to null,
                        "errorMessage" to null,
                ),
        )
    }

    fun sendInitCloudEvent(name: String, data: Any?)
    {
        val eventData = mapOf("name" to name, "data" to data)
        initCloudSink?.success(eventData)
    }

    fun sendNotification(name: String, data: Any?)
    {
        val eventData = mapOf("name" to name, "data" to data)
        handleNotificationSink?.success(eventData)
    }
}
