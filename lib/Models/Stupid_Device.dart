class Stupid_Device
{
  int? id;
  String name;
  int clientId;
  String measurementName;
  List fields;

  Stupid_Device(
      {this.id=null, required this.name, required this.clientId, required this.measurementName, required this.fields});

  factory Stupid_Device.fromJson(Map<String,dynamic> json)
  {
    try {
      final id = json["id"];
      final name = json["name"] ?? "none";
      final clientId = json["client_id"] ?? -1;
      final measurementName = json["measurement_name"] ?? "none";
      final fields = (json["fields"] ?? []).map((e) => e as String).toList();
      return Stupid_Device(id: id,
          name: name,
          clientId: clientId,
          measurementName: measurementName,
          fields: fields);
    }
    catch (e)
    {
      print(e);
      return Stupid_Device(name: "fDefault", clientId: -1, measurementName: "fDefault", fields: []);
    }
  }

  static Stupid_Device dump()
  {
    return Stupid_Device(clientId: -1,fields: [],measurementName: "",name: "",id: -1);
  }

  Map<String,dynamic> toJson()=>{
    "id":id,
    "name":name,
    "client_id":clientId,
    "measurement_name":measurementName,
    "fields":fields
  };
}