import 'package:latlong2/latlong.dart';

class HiddenGemData {
  // Basic Information
  String? name;
  String? description;
  String? category;
  List<String>? tags;

  // Location Information
  LatLng? location;
  String? locationName;
  String? address;
  String? city;
  String? region;

  // Images
  List<String> images;
  String? coverImage;

  // Additional Details
  String? difficulty;
  String? bestTimeToVisit;
  double? entryFee;
  String? accessInfo;
  String? facilities;

  // Contact & Operator
  String? contactPhone;
  String? contactEmail;
  String? website;
  Map<String, dynamic>? operator;

  // Metadata
  DateTime? createdAt;
  String? createdBy;
  bool isDraft;

  HiddenGemData({
    this.name,
    this.description,
    this.category,
    this.tags,
    this.location,
    this.locationName,
    this.address,
    this.city,
    this.region,
    this.images = const [],
    this.coverImage,
    this.difficulty,
    this.bestTimeToVisit,
    this.entryFee,
    this.accessInfo,
    this.facilities,
    this.contactPhone,
    this.contactEmail,
    this.website,
    this.operator,
    this.createdAt,
    this.createdBy,
    this.isDraft = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'tags': tags,
      'location': location != null
          ? {'lat': location!.latitude, 'lng': location!.longitude}
          : null,
      'locationName': locationName,
      'address': address,
      'city': city,
      'region': region,
      'images': images,
      'coverImage': coverImage,
      'difficulty': difficulty,
      'bestTimeToVisit': bestTimeToVisit,
      'entryFee': entryFee,
      'accessInfo': accessInfo,
      'facilities': facilities,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'website': website,
      'operator': operator,
      'createdAt': createdAt?.toIso8601String(),
      'createdBy': createdBy,
      'isDraft': isDraft,
    };
  }

  factory HiddenGemData.fromJson(Map<String, dynamic> json) {
    return HiddenGemData(
      name: json['name'],
      description: json['description'],
      category: json['category'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      location: json['location'] != null
          ? LatLng(json['location']['lat'], json['location']['lng'])
          : null,
      locationName: json['locationName'],
      address: json['address'],
      city: json['city'],
      region: json['region'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      coverImage: json['coverImage'],
      difficulty: json['difficulty'],
      bestTimeToVisit: json['bestTimeToVisit'],
      entryFee: json['entryFee']?.toDouble(),
      accessInfo: json['accessInfo'],
      facilities: json['facilities'],
      contactPhone: json['contactPhone'],
      contactEmail: json['contactEmail'],
      website: json['website'],
      operator: json['operator'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      createdBy: json['createdBy'],
      isDraft: json['isDraft'] ?? true,
    );
  }

  bool get isValid {
    return name != null &&
        name!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty &&
        location != null &&
        images.length >= 4 &&
        category != null;
  }

  double get completionPercentage {
    int totalFields = 10;
    int completedFields = 0;

    if (name != null && name!.isNotEmpty) completedFields++;
    if (description != null && description!.isNotEmpty) completedFields++;
    if (category != null) completedFields++;
    if (location != null) completedFields++;
    if (images.length >= 4) completedFields++;
    if (difficulty != null) completedFields++;
    if (bestTimeToVisit != null) completedFields++;
    if (accessInfo != null && accessInfo!.isNotEmpty) completedFields++;
    if (tags != null && tags!.isNotEmpty) completedFields++;
    if (locationName != null && locationName!.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }
}
