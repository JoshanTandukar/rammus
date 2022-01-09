import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live/ui/agora/agorConfig.dart' as config;
import 'package:live/ui/agora/agoraDetails.dart';

import 'advanced/index.dart';
import 'basic/index.dart';
import 'basic/join_channel_video/join_channel_video.dart';

class AgoraViewPage extends StatelessWidget {
  // final _DATA = [...Basic, ...Advanced];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: JoinChannelVideo(channelName: "Peeq-Channel-Name",token: "006afe89f63f8d74618867915910ffa0aaeIADmQvvVq8WJJJRU8lUnjpSQVILDtxFQdTaM+uj+c1QvvQsD2LAAAAAAIgCAn/0BF6u4YQQAAQCnZ7dhAgCnZ7dhAwCsadfnZ7dhBACnZ7dh",appId: appId,uid:0),
      // body: JoinChannelVideo(channelName: AgoraDetail.channelId,token: AgoraDetail.token,appId: AgoraDetail.appId,uid:AgoraDetail.uid),
    );
  }
}

class InvalidConfigWidget extends StatelessWidget {
  const InvalidConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text(
          'Make sure you set the correct appId, token, channelId, etc.. in the lib/config/agora.config.dart file.'),
    );
  }
}