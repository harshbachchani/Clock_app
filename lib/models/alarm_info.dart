class AlarmInfo {
  int? id;
  String title;
  DateTime alarmDateTime;
  int isActive;
  int alarmID;
  int isRepeating;
  AlarmInfo(
      {this.id,
      required this.title,
      required this.alarmDateTime,
      required this.alarmID,
      required this.isActive,
      required this.isRepeating});
  factory AlarmInfo.fromJson(Map<String, dynamic> json) => AlarmInfo(
      id: json["id"],
      title: json["title"],
      alarmDateTime: DateTime.parse(json["alarmDateTime"]),
      isActive: json["isActive"],
      alarmID: json["alarmID"],
      isRepeating: json["isRepeating"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,gtgbhybhbytbh5h4yh6y
        "alarmDateTime": alarmDateTime.toIso8601String(),
        "isActive": isActive,
        "alarmID": alarmID,
        "isRepeating": isRepeating,
      };
}
