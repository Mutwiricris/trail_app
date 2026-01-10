class SignupData {
  String? firstName;
  String? lastName;
  DateTime? birthday;
  String? referralSource;
  String? gender;
  String? homeCountry;
  List<String> travelStyles = [];
  List<String> interests = [];
  String? profilePhotoPath;
  bool notificationsEnabled = false;
  List<String> activityPreferences = [];
  bool locationEnabled = false;
  bool showDistanceAway = true;
  String? email;
  String? password;

  SignupData();

  bool get isComplete {
    return firstName != null &&
        lastName != null &&
        birthday != null &&
        gender != null &&
        homeCountry != null &&
        travelStyles.isNotEmpty &&
        interests.isNotEmpty &&
        email != null &&
        password != null;
  }
}
