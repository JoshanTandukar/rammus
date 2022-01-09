import 'package:live/viewobject/common/Object.dart';
import 'package:live/viewobject/model/appInfo/AppVersion.dart';

class AppInfoData extends Object<AppInfoData>
{
  AppInfoData({
    this.status,
    this.appVersion,
  });

  int? status;
  AppVersion? appVersion;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AppInfoData fromMap(dynamic dynamicData)
  {
    return AppInfoData(
      status: dynamicData['status'],
      appVersion: AppVersion().fromMap(dynamicData['data']),
    );
  }

  @override
  Map<String, dynamic> toMap(AppInfoData object)
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = object.status;
    data['data'] = AppVersion().toMap(object.appVersion);
    return data;
  }

  @override
  List<AppInfoData> fromMapList(List<dynamic>? dynamicDataList)
  {
    final List<AppInfoData> login = <AppInfoData>[];
    if (dynamicDataList != null)
    {
      for (dynamic dynamicData in dynamicDataList)
      {
        if (dynamicData != null)
        {
          login.add(fromMap(dynamicData));
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<AppInfoData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (AppInfoData? data in objectList)
    {
      if (data != null)
      {
        mapList.add(toMap(data));
      }
    }
    return mapList;
  }
}