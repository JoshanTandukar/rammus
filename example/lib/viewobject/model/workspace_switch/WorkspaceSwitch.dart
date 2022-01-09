import 'package:live/viewobject/common/Object.dart';
import 'package:live/viewobject/model/workspace_switch/WorkspaceSwitchData.dart';

class WorkspaceSwitch extends Object<WorkspaceSwitch>
{
  WorkspaceSwitch({
    required this.workspaceSwitch,
  });

  WorkspaceSwitchData workspaceSwitch;

  @override
  String getPrimaryKey()
  {
    return "";
  }

  @override
  WorkspaceSwitch fromMap(dynamic dynamicData)
  {
    return WorkspaceSwitch(workspaceSwitch: WorkspaceSwitchData().fromMap(dynamicData['changeDefaultWorkspace']),);
  }

  @override
  Map<String, dynamic> toMap(WorkspaceSwitch? object)
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workspace'] = WorkspaceSwitchData().toMap(object!.workspaceSwitch);
    return data;
  }

  @override
  List<WorkspaceSwitch> fromMapList(List<dynamic> dynamicDataList)
  {
    final List<WorkspaceSwitch> data = <WorkspaceSwitch>[];
    for (dynamic json in dynamicDataList)
    {
      if (json != null)
      {
        data.add(fromMap(json));
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<WorkspaceSwitch> objectList)
  {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (WorkspaceSwitch data in objectList)
    {
      mapList.add(toMap(data));
    }
    return mapList;
  }
}