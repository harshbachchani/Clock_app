class TimerInfo {
  int? id;
  String title;
  int hour;
  int minute;
  int second;
  TimerInfo({
    this.id,
    required this.title,
    required this.hour,
    required this.minute,
    required this.second,
  });

  factory TimerInfo.fromJson(Map<String, dynamic> json) => TimerInfo(
        id: json["id"],
        title: json["title"],
        hour: json["hour"],
        minute: json["minute"],
        second: json["second"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "hour": hour,
        "minute": minute,
        "second": second,
      };
}
