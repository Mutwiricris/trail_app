/// User profile model
class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? photoUrl;
  final String? bio;
  final ExplorerLevel level;
  final int currentXP;
  final int streakDays;
  final DateTime joinedDate;
  final List<String> unlockedBadges;

  // Personal Information (Signup Data)
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? nationality;
  final String? idNumber;
  final String? passportNumber;

  // Address Information
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;

  // Preferences
  final List<String>? interests;
  final List<String>? languages;
  final String? preferredCurrency;
  final bool? emailNotifications;
  final bool? smsNotifications;
  final bool? pushNotifications;

  // Emergency Contact
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;

  // Travel Preferences
  final String? travelStyle; // Adventure, Luxury, Budget, etc.
  final List<String>? dietaryRestrictions;
  final List<String>? accessibility;
  final bool? travelInsurance;

  // Trip and visit tracking
  final List<String> savedGemIds;
  final List<String> visitedGemIds;
  final List<String> savedSafariIds;
  final List<String> visitedSafariIds;
  final List<String> savedRouteIds;
  final List<String> completedRouteIds;

  // Trip statistics
  final int totalTripsCount;
  final int completedTripsCount;
  final int totalVisitsCount;

  // Account Settings
  final bool? isProfilePublic;
  final bool? shareLocationWithFriends;
  final DateTime? lastActive;

  UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.bio,
    this.level = ExplorerLevel.explorer,
    this.currentXP = 0,
    this.streakDays = 0,
    required this.joinedDate,
    this.unlockedBadges = const [],
    // Personal Information
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.idNumber,
    this.passportNumber,
    // Address
    this.address,
    this.city,
    this.country,
    this.postalCode,
    // Preferences
    this.interests,
    this.languages,
    this.preferredCurrency,
    this.emailNotifications,
    this.smsNotifications,
    this.pushNotifications,
    // Emergency Contact
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    // Travel Preferences
    this.travelStyle,
    this.dietaryRestrictions,
    this.accessibility,
    this.travelInsurance,
    // Trip tracking
    this.savedGemIds = const [],
    this.visitedGemIds = const [],
    this.savedSafariIds = const [],
    this.visitedSafariIds = const [],
    this.savedRouteIds = const [],
    this.completedRouteIds = const [],
    this.totalTripsCount = 0,
    this.completedTripsCount = 0,
    this.totalVisitsCount = 0,
    // Account Settings
    this.isProfilePublic,
    this.shareLocationWithFriends,
    this.lastActive,
  });

  // Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  // Get full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return name;
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return email != null &&
        phoneNumber != null &&
        dateOfBirth != null &&
        nationality != null;
  }

  // Calculate profile completion percentage
  int get profileCompletionPercentage {
    int totalFields = 15;
    int completedFields = 0;

    if (email != null && email!.isNotEmpty) completedFields++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) completedFields++;
    if (photoUrl != null && photoUrl!.isNotEmpty) completedFields++;
    if (bio != null && bio!.isNotEmpty) completedFields++;
    if (dateOfBirth != null) completedFields++;
    if (nationality != null && nationality!.isNotEmpty) completedFields++;
    if (address != null && address!.isNotEmpty) completedFields++;
    if (city != null && city!.isNotEmpty) completedFields++;
    if (country != null && country!.isNotEmpty) completedFields++;
    if (interests != null && interests!.isNotEmpty) completedFields++;
    if (languages != null && languages!.isNotEmpty) completedFields++;
    if (emergencyContactName != null && emergencyContactName!.isNotEmpty)
      completedFields++;
    if (emergencyContactPhone != null && emergencyContactPhone!.isNotEmpty)
      completedFields++;
    if (travelStyle != null && travelStyle!.isNotEmpty) completedFields++;
    if (preferredCurrency != null && preferredCurrency!.isNotEmpty)
      completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }

  /// Progress to next level (0.0 to 1.0)
  double get levelProgress {
    final xpForNextLevel = level.xpRequired;
    final xpForCurrentLevel = level.index > 0
        ? ExplorerLevel.values[level.index - 1].xpRequired
        : 0;
    final xpRange = xpForNextLevel - xpForCurrentLevel;
    final xpInCurrentLevel = currentXP - xpForCurrentLevel;
    return (xpInCurrentLevel / xpRange).clamp(0.0, 1.0);
  }

  /// XP needed for next level
  int get xpToNextLevel {
    return level.xpRequired - currentXP;
  }
}

/// Explorer levels
enum ExplorerLevel {
  explorer(100),
  pathfinder(500),
  trailblazer(1500),
  pioneer(3000),
  legend(5000);

  final int xpRequired;
  const ExplorerLevel(this.xpRequired);

  String get displayName {
    switch (this) {
      case ExplorerLevel.explorer:
        return 'Explorer';
      case ExplorerLevel.pathfinder:
        return 'Pathfinder';
      case ExplorerLevel.trailblazer:
        return 'Trailblazer';
      case ExplorerLevel.pioneer:
        return 'Pioneer';
      case ExplorerLevel.legend:
        return 'Legend';
    }
  }

  String get icon {
    switch (this) {
      case ExplorerLevel.explorer:
        return '🗺️';
      case ExplorerLevel.pathfinder:
        return '🧭';
      case ExplorerLevel.trailblazer:
        return '⛰️';
      case ExplorerLevel.pioneer:
        return '🏔️';
      case ExplorerLevel.legend:
        return '👑';
    }
  }
}
