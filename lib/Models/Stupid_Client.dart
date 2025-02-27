class Stupid_Client
{
  int? id;
  String name;
  String? key;
  List managementsId;
  List devicesId;

  Stupid_Client(
      {
        this.id,
        required this.name,
        this.key,
        this.managementsId=const [],
        this.devicesId=const []
      });

  factory Stupid_Client.fromJson(Map<String,dynamic> json)
  {
    final id=json["id"];
    final name=json["name"]??"none";
    final key=json["key"]??"none";
    final managementsId=(json["managements_id"]??[]).map((e) => e as int).toList();
    final devicesId=(json["devices_id"]??[]).map((e) => e as int).toList();
    return Stupid_Client(
      id:id,
      name: name,
      key: key,
      managementsId: managementsId,
      devicesId: devicesId
    );
  }

  Map<String,dynamic> toJson()=>{
    "id":id,
    "name":name,
    "key":key,
    "managements_id":managementsId,
    "devices_id":devicesId
  };
}