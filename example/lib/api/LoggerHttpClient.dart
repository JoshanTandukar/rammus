import 'dart:convert';
import 'package:http/http.dart';

/// Show logs of GraphQL connection
class LoggerHttpClient extends BaseClient {
  LoggerHttpClient(this._client);

  final Client _client;

  @override
  void close() {
    _client.close();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request).then((StreamedResponse response) async {
      final String responseString = await response.stream.bytesToString();

      return StreamedResponse(
        ByteStream.fromBytes(utf8.encode(responseString)),
        response.statusCode,
        headers: response.headers,
        reasonPhrase: response.reasonPhrase,
        persistentConnection: response.persistentConnection,
        contentLength: response.contentLength,
        isRedirect: response.isRedirect,
        request: response.request,
      );
    });
  }
}