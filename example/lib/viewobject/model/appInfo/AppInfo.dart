import 'package:live/viewobject/common/Object.dart';
import 'package:live/viewobject/model/appInfo/AppInfoData.dart';

class AppInfo extends Object<AppInfo>
{
  AppInfo({
    this.appRegisterInfo,
  });

  AppInfoData? appRegisterInfo;

  @override
  String getPrimaryKey()
  {
    return '';
  }

  @override
  AppInfo fromMap(dynamic dynamicData)
  {
    return AppInfo(
      appRegisterInfo: AppInfoData().fromMap(dynamicData['appRegisterInfo']),
    );
  }

  @override
  Map<String, dynamic> toMap(dynamic object)
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = AppInfoData().toMap(object.appInfo);
    return data;
  }

  @override
  List<AppInfo> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<AppInfo> psAppVersionList = <AppInfo>[];
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
  List<Map<String, dynamic>> toMapList(List<AppInfo> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (AppInfo data in objectList)
    {
      mapList.add(toMap(data));
    }
    return mapList;
  }
}
