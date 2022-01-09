
import 'Status.dart';

class Resources<T>
{
  Resources(this.status, this.message, this.data);
  final Status status;
  final String message;
  T data;
}
