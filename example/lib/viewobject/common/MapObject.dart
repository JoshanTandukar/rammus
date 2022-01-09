import 'package:live/viewobject/common/Object.dart';

abstract class MapObject<T> extends Object<T>
{
  int? sorting;
  List<String> getIdList(List<T> mapList);
  List<String> getIdByKeyValue(List<T> mapList,dynamic key ,dynamic value );
}
