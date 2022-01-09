package com.jarvanmo.rammus

import androidx.annotation.NonNull
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/***
 * Created by mo on 2019-06-25
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
class RammusPluginHandler : MethodChannel.MethodCallHandler
{
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result)
    {
        when (call.method)
        {
            "deviceId" -> result.success(PushServiceFactory.getCloudPushService().deviceId)
            "initPushService" -> RammusPlugin.initPushService(result)
            "turnOnPushChannel" -> RammusPlugin.instance.turnOnPushChannel(result)
            "turnOffPushChannel" -> RammusPlugin.instance.turnOffPushChannel(result)
            "checkPushChannelStatus" -> RammusPlugin.instance.checkPushChannelStatus(result)
            "bindAccount" -> RammusPlugin.instance.bindAccount(call, result)
            "unbindAccount" -> RammusPlugin.instance.unbindAccount(result)
            "bindTag" -> RammusPlugin.instance.bindTag(call, result)
            "unbindTag" -> RammusPlugin.instance.unbindTag(call, result)
            "listTags" -> RammusPlugin.instance.listTags(call, result)
            "addAlias" -> RammusPlugin.instance.addAlias(call, result)
            "removeAlias" -> RammusPlugin.instance.removeAlias(call, result)
            "listAliases" -> RammusPlugin.instance.listAliases(result)
            "setupNotificationManager" -> RammusPlugin.instance.setupNotificationManager(call, result)
            "bindPhoneNumber" -> RammusPlugin.instance.bindPhoneNumber(call, result)
            "unbindPhoneNumber" -> RammusPlugin.instance.unbindPhoneNumber(result)
            else -> result.notImplemented()
        }
    }
}