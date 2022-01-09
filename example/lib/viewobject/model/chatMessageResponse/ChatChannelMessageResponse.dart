
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';

class ChatChannelMessageResponse
{
  List<Messages>? messages;
  bool? success;
  String? error;

  ChatChannelMessageResponse({this.messages, this.success});

  ChatChannelMessageResponse.fromJson(Map<String, dynamic> json)
  {
    if (json['messages'] != null)
    {
      messages = <Messages>[];
      json['messages'].forEach((v)
      {
        messages!.add( Messages.fromJson(v));
      });
    }
    success = json['success'];
    success = json['error'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.messages != null)
    {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['error'] = this.error;
    return data;
  }
}

class Messages
{
  String? sId;
  String? rid;
  String? msg;
  Ts? ts;
  U? u;
  String? sUpdatedAt;
  List<Md>? md;
  String? t;
  bool? groupAble;
  FileObject? fileObject;
  List<Attachments>? attachments;
  Reactions? reactions;

  Messages({
    this.sId,
    this.rid,
    this.msg,
    this.ts,
    this.u,
    this.sUpdatedAt,
    this.md,
    this.t,
    this.groupAble,
    this.fileObject,
    this.attachments,
    this.reactions,
  });

  Messages.fromJson(Map<String, dynamic> json)
  {
    sId = json['_id'];
    rid = json['rid'];
    if(json.containsKey("t"))
    {
      t = json['t'];
      if(json['t']=="uj")
      {
        msg = json['msg']+" joined the room.";
      }
      else if(json['t']=="ul")
      {
        msg = json['msg']+" left the room.";
      }
      else
      {
        msg = json['msg'];
      }
    }
    else
    {
      t=null;
      msg = json['msg'];
    }
    ts = json['ts']!=null? Ts.fromJson(json['ts']):null;
    u = json['u'] != null ? U.fromJson(json['u']) : null;
    if (json['md'] != null)
    {
      md = <Md>[];
      json['md'].forEach((v)
      {
        md!.add( Md.fromJson(v));
      });
    }
    if (json['attachments'] != null)
    {
      attachments =  <Attachments>[];
      json['attachments'].forEach((v)
      {
        attachments!.add( Attachments.fromJson(v));
      });
    }
    groupAble = json['groupable'];
    fileObject = json['file'] != null ? FileObject.fromJson(json['file']) : null;
    reactions = json.containsKey("reactions")? Reactions.fromJson(json['reactions']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rid'] = this.rid;
    data['msg'] = this.msg;
    if (this.ts != null)
    {
      data['ts'] = this.ts!.toJson();
    }
    if (this.u != null)
    {
      data['u'] = this.u!.toJson();
    }
    if (this.md != null)
    {
      data['md'] = this.md!.map((v) => v.toJson()).toList();
    }
    if (this.fileObject != null)
    {
      data['file'] = this.fileObject!.toJson();
    }
    if (this.attachments != null)
    {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    data['t'] = this.t;
    data['groupable'] = this.groupAble;
    data['reactions'] = this.reactions;
    return data;
  }
}

class Ts
{
  int? date;

  Ts({this.date});

  Ts.fromJson(Map<String, dynamic> json)
  {
    date = json['\$date'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['\$date'] = this.date;
    return data;
  }
}
class Md
{
  String? type;
  List<Value>? value;

  Md({this.type, this.value});

  Md.fromJson(Map<String, dynamic> json)
  {
    type = json['type'];
    if (json['value'] != null)
    {
      value = <Value>[];
      json['value'].forEach((v)
      {
        value!.add(Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['type'] = this.type;
    if (this.value != null)
    {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value
{
  String? type;
  //TODO map list or string
  // String? value;

  Value({this.type});

  Value.fromJson(Map<String, dynamic> json)
  {
    type = json['type'];
    // value = json['value'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['type'] = this.type;
    // data['value'] = this.value;
    return data;
  }
}

class FileObject
{
  String? sId;
  String? name;
  String? type;

  FileObject({this.sId, this.name, this.type});

  FileObject.fromJson(Map<String, dynamic> json)
  {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Attachments
{
  String? ts;
  String? title;
  String? titleLink;
  bool? titleLinkDownload;
  ImageDimensions? imageDimensions;
  String? imagePreview;
  String? imageUrl;
  String? imageType;
  int? imageSize;
  String? type;
  String? videoUrl;
  String? videoType;
  int? videoSize;
  String? description;

  Attachments({
    this.ts,
    this.title,
    this.titleLink,
    this.titleLinkDownload,
    this.imageDimensions,
    this.imagePreview,
    this.imageUrl,
    this.imageType,
    this.imageSize,
    this.type,
    this.videoUrl,
    this.videoType,
    this.videoSize,
    this.description
  });

  Attachments.fromJson(Map<String, dynamic> json) 
  {
    ts = json['ts'];
    title = json['title'];
    titleLink = json['title_link'];
    titleLinkDownload = json['title_link_download'];
    imageDimensions = json['image_dimensions'] != null
        ?  ImageDimensions.fromJson(json['image_dimensions'])
        : null;
    imagePreview = json['image_preview'];
    imageUrl = json['image_url'];
    imageType = json['image_type'];
    imageSize = json['image_size'];
    type = json['type'];
    videoUrl = json['video_url'];
    videoType = json['video_type'];
    videoSize = json['video_size'];
    description = json['description'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['ts'] = this.ts;
    data['title'] = this.title;
    data['title_link'] = this.titleLink;
    data['title_link_download'] = this.titleLinkDownload;
    if (this.imageDimensions != null)
    {
      data['image_dimensions'] = this.imageDimensions!.toJson();
    }
    data['image_preview'] = this.imagePreview;
    data['image_url'] = this.imageUrl;
    data['image_type'] = this.imageType;
    data['image_size'] = this.imageSize;
    data['type'] = this.type;
    data['video_url'] = this.videoUrl;
    data['video_type'] = this.videoType;
    data['video_size'] = this.videoSize;
    data['description'] = this.description;
    return data;
  }
}

class ImageDimensions
{
  int? width;
  int? height;

  ImageDimensions({this.width, this.height});

  ImageDimensions.fromJson(Map<String, dynamic> json)
  {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Reactions {
  Heart? heart;

  Reactions({this.heart});

  Reactions.fromJson(Map<String, dynamic> json) 
  {
    heart = json.containsKey(':heart:') ?  Heart.fromJson(json[':heart:']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.heart != null)
    {
      data[':heart:'] = this.heart!.toJson();
    }
    return data;
  }
}

class Heart 
{
  List<String>? usernames;

  Heart({this.usernames});

  Heart.fromJson(Map<String, dynamic> json) 
  {
    usernames = json['usernames'].cast<String>();
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['usernames'] = this.usernames;
    return data;
  }
}