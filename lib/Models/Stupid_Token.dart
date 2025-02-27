import 'dart:convert';

class StupidToken
{
  final String accessToken;
  final String tokenType;
  final DateTime exp;

  factory StupidToken(String token, String type, String exp)
  {
    DateTime time=DateTime.parse(exp).toLocal();
    return StupidToken._internal(token, type, time);
  }

  factory StupidToken.fromJson(String raw)
  {
    Map<String,dynamic> json=jsonDecode(raw) as Map<String,dynamic>;
    return StupidToken(json["access_token"], json["token_type"], json["exp"]);
  }

  Map<String,dynamic> toJson()=>
      {
        "access_token":accessToken,
        "token_type":tokenType,
        "exp":exp.toIso8601String()
      };

  StupidToken._internal(this.accessToken, this.tokenType, this.exp);
}