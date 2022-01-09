import 'package:live/config/Config.dart';
import 'package:quiver/core.dart';
import 'package:live/viewobject/common/Object.dart';

class AppVersion extends Object<AppVersion>
{
  AppVersion({
    this.versionNo = Config.appVersion,
    this.versionForceUpdate,
    this.versionNeedClearData
  });
  String versionNo;
  bool? versionForceUpdate;
  bool? versionNeedClearData;

  @override
  bool operator ==(dynamic other) => other is AppVersion && versionNo == other.versionNo;


  @override
  int get hashCode => hash2(versionNo.hashCode, versionNo.hashCode);

  @override
  String getPrimaryKey()
  {
    return versionNo;
  }

  @override
  AppVersion fromMap(dynamic dynamicData)
  {
    return AppVersion(
        versionNo: dynamicData['versionNo'],
        versionForceUpdate: dynamicData['versionForceUpdate'],
        versionNeedClearData: dynamicData['versionNeedClearData']
    );
  }

  @override
  Map<String, dynamic> toMap(dynamic object)
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['versionNo'] = object.versionNo;
    data['versionForceUpdate'] = object.versionForceUpdate;
    data['versionNeedClearData'] = object.versionNeedClearData;
    return data;
  }

  @override
  List<AppVersion> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AppVersion> psAppVersionList = <AppVersion>[];
    for (dynamic json in dynamicDataList)
    {
      if (json != null)
      {
        psAppVersionList.add(fromMap(json));
      }
    }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<AppVersion> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (AppVersion data in objectList)
    {
      mapList.add(toMap(data));
    }
    return mapList;
  }
}
