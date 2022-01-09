package com.peeqlive

import com.jarvanmo.rammus.RammusPlugin
import io.flutter.plugin.common.PluginRegistry
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.loader.FlutterLoader

/***
 * Created by mo on 2019-06-25
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
class MyApplication:FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterLoader()
        RammusPlugin.initPushService(this)
    }

    override fun registerWith(registry: PluginRegistry?)
    {
    }
}