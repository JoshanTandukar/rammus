

import 'package:live/ui/agora/advanced/stream_message/stream_message.dart';
import 'package:live/ui/agora/advanced/voice_changer/voice_changer.dart';

import 'channel_media_relay/channel_media_relay.dart';
import 'custom_capture_audio/custom_capture_audio.dart';
import 'join_multiple_channel/join_multiple_channel.dart';

/// Data source for advanced examples
final Advanced = [
  {'name': 'Advanced'},
  {'name': 'JoinMultipleChannel', 'widget': JoinMultipleChannel()},
  {
    'name': 'StreamMessage',
    'widget': StreamMessage(),
  },
  {
    'name': 'ChannelMediaRelay',
    'widget': ChannelMediaRelay(),
  },
  {'name': 'VoiceChanger', 'widget': VoiceChanger()},
  {'name': 'CustomCaptureAudio', 'widget': CustomCaptureAudio()},
];
