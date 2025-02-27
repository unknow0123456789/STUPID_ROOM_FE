class Stupid_User
{
  String? username;
  String? password;

  Stupid_User(this.username, this.password);

  Stupid_User.fromJson(Map<String,dynamic> json)
  {
    username=json["username"];
    password=json["password"];
  }

  Map<String,dynamic> toJson()=>{
    "username":username,
    "password":password
  };

}