import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

const String url = 'https://pub.dev/packages';

class HttpService {
  static Future<String?> getPackage(int? page) async {
    try {
      final dio = Dio();
      Map<String, dynamic> data = {
        'page': page,
      };
      final response = await dio.get(url, queryParameters: data);
      print(response.realUri);
      if (response.statusCode == 200) return response.data;
    } catch (e) {
      print("HttpServiceCatch $e");
    }
    return null;
  }
}
