/// Model for storing activity creation data
class ActivityData {
  String? category;
  String? type;
  String? description;
  String? locationType; // 'general' or 'specific'
  String? generalArea;
  double? latitude;
  double? longitude;
  DateTime? date;
  String? timeType; // 'flexible' or 'specific'
  String? specificTime;
  int minAge;
  int maxAge;
  String privacy; // 'open' or 'private'

  ActivityData({
    this.category,
    this.type,
    this.description,
    this.locationType,
    this.generalArea,
    this.latitude,
    this.longitude,
    this.date,
    this.timeType,
    this.specificTime,
    this.minAge = 18,
    this.maxAge = 38,
    this.privacy = 'open',
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'type': type,
      'description': description,
      'locationType': locationType,
      'generalArea': generalArea,
      'latitude': latitude,
      'longitude': longitude,
      'date': date?.toIso8601String(),
      'timeType': timeType,
      'specificTime': specificTime,
      'minAge': minAge,
      'maxAge': maxAge,
      'privacy': privacy,
    };
  }
}
