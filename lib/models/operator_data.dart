class OperatorData {
  String? id;
  String? name;
  String? logoUrl;
  String? coverImage;
  String? description;
  String? tagline;

  // Contact Information
  String? email;
  String? phone;
  String? website;
  String? address;
  String? city;
  String? country;

  // Verification & Trust
  bool isVerified;
  String? verificationBadge;
  DateTime? memberSince;
  String? licenseNumber;

  // Rating & Reviews
  double? rating;
  int? reviewCount;
  int? totalBookings;

  // Statistics
  int? toursOffered;
  int? accommodationsOffered;
  List<String>? specializations;
  List<String>? certifications;

  // Social Media
  Map<String, String>? socialLinks;

  // Business Info
  String? businessType; // Tour Operator, Hotel, Camp, Lodge, etc.
  List<String>? services; // Tours, Accommodation, Transport, etc.
  Map<String, dynamic>? operatingHours;
  List<String>? languages;

  // Gallery
  List<String>? gallery;

  // Policies
  String? cancellationPolicy;
  String? paymentTerms;
  String? safetyMeasures;

  OperatorData({
    this.id,
    this.name,
    this.logoUrl,
    this.coverImage,
    this.description,
    this.tagline,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.city,
    this.country,
    this.isVerified = false,
    this.verificationBadge,
    this.memberSince,
    this.licenseNumber,
    this.rating,
    this.reviewCount,
    this.totalBookings,
    this.toursOffered,
    this.accommodationsOffered,
    this.specializations,
    this.certifications,
    this.socialLinks,
    this.businessType,
    this.services,
    this.operatingHours,
    this.languages,
    this.gallery,
    this.cancellationPolicy,
    this.paymentTerms,
    this.safetyMeasures,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'coverImage': coverImage,
      'description': description,
      'tagline': tagline,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address,
      'city': city,
      'country': country,
      'isVerified': isVerified,
      'verificationBadge': verificationBadge,
      'memberSince': memberSince?.toIso8601String(),
      'licenseNumber': licenseNumber,
      'rating': rating,
      'reviewCount': reviewCount,
      'totalBookings': totalBookings,
      'toursOffered': toursOffered,
      'accommodationsOffered': accommodationsOffered,
      'specializations': specializations,
      'certifications': certifications,
      'socialLinks': socialLinks,
      'businessType': businessType,
      'services': services,
      'operatingHours': operatingHours,
      'languages': languages,
      'gallery': gallery,
      'cancellationPolicy': cancellationPolicy,
      'paymentTerms': paymentTerms,
      'safetyMeasures': safetyMeasures,
    };
  }

  factory OperatorData.fromJson(Map<String, dynamic> json) {
    return OperatorData(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      coverImage: json['coverImage'],
      description: json['description'],
      tagline: json['tagline'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      isVerified: json['isVerified'] ?? false,
      verificationBadge: json['verificationBadge'],
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'])
          : null,
      licenseNumber: json['licenseNumber'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      totalBookings: json['totalBookings'],
      toursOffered: json['toursOffered'],
      accommodationsOffered: json['accommodationsOffered'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : null,
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
      socialLinks: json['socialLinks'] != null
          ? Map<String, String>.from(json['socialLinks'])
          : null,
      businessType: json['businessType'],
      services: json['services'] != null
          ? List<String>.from(json['services'])
          : null,
      operatingHours: json['operatingHours'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'])
          : null,
      cancellationPolicy: json['cancellationPolicy'],
      paymentTerms: json['paymentTerms'],
      safetyMeasures: json['safetyMeasures'],
    );
  }

  // Get mock operators for demo
  static List<OperatorData> getMockOperators() {
    return [
      OperatorData(
        id: 'op1',
        name: 'Safari Adventures Ltd',
        logoUrl: 'https://i.pravatar.cc/200?img=1',
        coverImage: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
        description: 'Premier safari operator offering authentic wildlife experiences across Kenya\'s most spectacular national parks and reserves.',
        tagline: 'Your Gateway to Wild Kenya',
        email: 'info@safariadventures.co.ke',
        phone: '+254 712 345 678',
        website: 'www.safariadventures.co.ke',
        address: 'Kenyatta Avenue, Nairobi',
        city: 'Nairobi',
        country: 'Kenya',
        isVerified: true,
        verificationBadge: 'Kenya Tourism Board Certified',
        memberSince: DateTime(2018, 3, 15),
        licenseNumber: 'KTB-2018-0542',
        rating: 4.8,
        reviewCount: 342,
        totalBookings: 1250,
        toursOffered: 25,
        accommodationsOffered: 0,
        specializations: ['Safari Tours', 'Wildlife Photography', 'Cultural Tours'],
        certifications: ['KTB Certified', 'Eco-Tourism Award 2023', 'Safety Excellence'],
        services: ['Tours', 'Transport', 'Guide Services'],
        languages: ['English', 'Swahili', 'German', 'French'],
        gallery: [
          'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
          'https://images.unsplash.com/photo-1534445538923-14f2cd67e636?w=800',
          'https://images.unsplash.com/photo-1535338268104-3b4ac09f3b1a?w=800',
        ],
      ),
      OperatorData(
        id: 'op2',
        name: 'Serena Hotels & Resorts',
        logoUrl: 'https://i.pravatar.cc/200?img=2',
        coverImage: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        description: 'Luxury accommodations in Kenya\'s most breathtaking locations. Experience world-class hospitality in the heart of nature.',
        tagline: 'Luxury in the Wild',
        email: 'reservations@serena.co.ke',
        phone: '+254 720 123 456',
        website: 'www.serenahotels.com',
        address: 'Westlands, Nairobi',
        city: 'Nairobi',
        country: 'Kenya',
        isVerified: true,
        verificationBadge: '5-Star Certified',
        memberSince: DateTime(2015, 1, 10),
        rating: 4.9,
        reviewCount: 856,
        totalBookings: 3420,
        toursOffered: 5,
        accommodationsOffered: 12,
        specializations: ['Luxury Lodges', 'Safari Camps', 'Beach Resorts'],
        certifications: ['5-Star Rating', 'Green Key Award', 'TripAdvisor Excellence'],
        services: ['Accommodation', 'Tours', 'Spa', 'Fine Dining'],
        languages: ['English', 'Swahili', 'Italian', 'Spanish'],
      ),
      OperatorData(
        id: 'op3',
        name: 'Maasai Mara Eco Camp',
        logoUrl: 'https://i.pravatar.cc/200?img=3',
        coverImage: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800',
        description: 'Authentic eco-friendly camping experience in the Maasai Mara. Sustainable tourism that supports local communities.',
        tagline: 'Camp Under the Stars',
        email: 'bookings@maasaimaraeco.co.ke',
        phone: '+254 733 456 789',
        website: 'www.maasaimaraeco.co.ke',
        city: 'Maasai Mara',
        country: 'Kenya',
        isVerified: true,
        verificationBadge: 'Eco-Tourism Certified',
        memberSince: DateTime(2019, 6, 20),
        rating: 4.7,
        reviewCount: 189,
        totalBookings: 567,
        toursOffered: 8,
        accommodationsOffered: 3,
        specializations: ['Eco Camping', 'Cultural Experiences', 'Game Drives'],
        certifications: ['Eco-Tourism Gold', 'Community Partnership Award'],
        services: ['Camping', 'Tours', 'Cultural Visits'],
        languages: ['English', 'Swahili', 'Maa'],
      ),
    ];
  }
}
