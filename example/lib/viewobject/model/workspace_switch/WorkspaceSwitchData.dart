import 'package:live/viewobject/common/Object.dart';

class WorkspaceSwitchData extends Object<WorkspaceSwitchData>
{
  WorkspaceSwitchData({
    this.status,
  });

  int? status;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceSwitchData fromMap(dynamic dynamicData)
  {
    return WorkspaceSwitchData(
      status: dynamicData['status'],
    );
  }

  @override
  Map<String, dynamic> toMap(WorkspaceSwitchData object)
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = object.status;
    return data;
  }

  @override
  List<WorkspaceSwitchData> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<WorkspaceSwitchData> psAppVersionList = <WorkspaceSwitchData>[];
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
  List<Map<String, dynamic>> toMapList(List<WorkspaceSwitchData> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (WorkspaceSwitchData data in objectList)
    {
      mapList.add(toMap(data));
    }
    return mapList;
  }
}