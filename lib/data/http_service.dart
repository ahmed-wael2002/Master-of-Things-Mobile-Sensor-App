import 'package:dio/dio.dart';

class HttpService {
  final endpointUrl = 'https://learning.masterofthings.com/PostSensorData';
  final dio = Dio();

  Future<Map<String, dynamic>?> postRequest(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        endpointUrl,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data;
    } 
    catch (e) {
      return {
        'error': e.toString()
      };
    }
  }
}
