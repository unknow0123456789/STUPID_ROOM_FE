
import 'package:fe/Models/Stupid_Token.dart';
import 'package:fe/Models/Stupid_User.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HttpApi
{
  final String baseUrl;
  HttpApi(this.baseUrl);

  void testApi() async
  {
    const String endpoint="/api/v1/test";
    final uri=Uri.parse(baseUrl+endpoint);

    final response = await get(uri);

    if(response.statusCode==200)
      {
        print(response.body);
      }
  }
  Future<Response> registerApi (Stupid_User user) async
  {
    const String endpoint="/api/v1/user/register";
    final uri=Uri.parse(baseUrl+endpoint);
    String body=jsonEncode(user);
    // print(body);
    final response = await post(
      uri,
      body: body,
      headers: {
        "Content-Type":"application/json"
      }
    );
    return response;
  }

  Future<Response> loginApi(Stupid_User user) async
  {
    const String endpoint="/api/v1/user/token";
    final uri=Uri.parse(baseUrl+endpoint);
    Map<String,dynamic> body=user.toJson();
    // print(body);
    final response = await post(
        uri,
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
    );
    return response;
  }

  Future<Response> testToken(StupidToken stupidToken) async
  {
    const String endpoint="/api/v1/user/test_secure";
    final uri=Uri.parse(baseUrl+endpoint);
    final response= await post(
      uri,
      headers: {
        "Authorization": "Bearer ${stupidToken.accessToken}"
      }
    );
    return response;
  }

  Future<Response> getSelfClient(StupidToken stupidToken) async
  {
    const String endpoint="/api/v1/client/self";
    final uri=Uri.parse(baseUrl+endpoint);
    final response= await get(
        uri,
        headers: {
          "Authorization": "Bearer ${stupidToken.accessToken}"
        }
    );
    return response;
  }

  Future<Response> getClientDevices(StupidToken stupidToken,int clientId) async
  {
    String endpoint="/api/v1/client/devices?client_id=$clientId";
    final uri=Uri.parse(baseUrl+endpoint);
    final response= await get(
        uri,
        headers: {
          "Authorization": "Bearer ${stupidToken.accessToken}"
        }
    );
    return response;
  }

  Future<Response> getDeviceData(StupidToken stupidToken,int deviceId,int timeRange,String timeUnitLetter, List<String> fields) async
  {
    String endpoint="/api/v1/device/data?device_id=$deviceId&range=$timeRange&time_unit_letter=$timeUnitLetter";
    final uri=Uri.parse(baseUrl+endpoint);
    final response= await post(
        uri,
        headers: {
          "Authorization": "Bearer ${stupidToken.accessToken}",
          "Content-Type": "application/json"
        },
      body: jsonEncode(fields)
    );
    return response;
  }

}

// class DevHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(final SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }