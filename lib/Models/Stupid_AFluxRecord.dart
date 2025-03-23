class Stupid_AFluxRecord
{
  DateTime start;
  DateTime stop;
  DateTime time;
  dynamic value;
  String field;
  String measurement;
  Map<String,dynamic> tags;

  Stupid_AFluxRecord({
        required this.start,
        required this.stop,
        required this.time,
        required this.value,
        required this.field,
        required this.measurement,
        this.tags=const {}
  });

  factory Stupid_AFluxRecord.fromJson(Map<String,dynamic> json)
  {
    final start=DateTime.parse(json["start"] as String);
    final stop=DateTime.parse(json["stop"] as String);
    final time=DateTime.parse(json["time"] as String);
    final value=json["value"];
    final field=json["field"];
    final measurement=json["measurement"];
    final tags=json["tags"] as Map<String,dynamic>;
    return Stupid_AFluxRecord(
        start: start,
        stop: stop,
        time: time,
        value: value,
        field: field,
        measurement: measurement,
        tags: tags
    );
  }

}