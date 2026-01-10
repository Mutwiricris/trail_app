import 'package:latlong2/latlong.dart';

enum AccommodationType {
  hotel,
  lodge,
  camp,
  resort,
  guesthouse,
  cottage,
  villa,
}

enum RoomType {
  single,
  double,
  twin,
  suite,
  family,
  tent,
  cottage,
  villa,
}

class AccommodationData {
  String? id;
  String? name;
  String? operatorId;
  String? operatorName;
  AccommodationType? type;

  // Location
  LatLng? location;
  String? address;
  String? city;
  String? region;

  // Description
  String? description;
  String? tagline;
  List<String>? highlights;

  // Images
  List<String>? images;
  String? coverImage;

  // Pricing
  double? pricePerNight;
  String? currency;

  // Rating & Reviews
  double? rating;
  int? reviewCount;

  // Capacity
  int? totalRooms;
  int? maxGuests;
  List<RoomType>? availableRoomTypes;

  // Amenities
  List<String>? amenities;
  List<String>? services;

  // Features
  bool hasWifi;
  bool hasParking;
  bool hasPool;
  bool hasSpa;
  bool hasRestaurant;
  bool hasBar;
  bool hasGym;
  bool petsAllowed;
  bool hasAirConditioning;

  // Policies
  String? checkInTime;
  String? checkOutTime;
  String? cancellationPolicy;
  int? minimumStay; // nights

  // Nearby Attractions
  List<Map<String, dynamic>>? nearbyAttractions;

  // Special Offers
  bool hasSpecialOffer;
  double? discountPercentage;
  String? offerDescription;

  AccommodationData({
    this.id,
    this.name,
    this.operatorId,
    this.operatorName,
    this.type,
    this.location,
    this.address,
    this.city,
    this.region,
    this.description,
    this.tagline,
    this.highlights,
    this.images,
    this.coverImage,
    this.pricePerNight,
    this.currency = 'KES',
    this.rating,
    this.reviewCount,
    this.totalRooms,
    this.maxGuests,
    this.availableRoomTypes,
    this.amenities,
    this.services,
    this.hasWifi = false,
    this.hasParking = false,
    this.hasPool = false,
    this.hasSpa = false,
    this.hasRestaurant = false,
    this.hasBar = false,
    this.hasGym = false,
    this.petsAllowed = false,
    this.hasAirConditioning = false,
    this.checkInTime,
    this.checkOutTime,
    this.cancellationPolicy,
    this.minimumStay,
    this.nearbyAttractions,
    this.hasSpecialOffer = false,
    this.discountPercentage,
    this.offerDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'operatorId': operatorId,
      'operatorName': operatorName,
      'type': type?.name,
      'location': location != null
          ? {'lat': location!.latitude, 'lng': location!.longitude}
          : null,
      'address': address,
      'city': city,
      'region': region,
      'description': description,
      'tagline': tagline,
      'highlights': highlights,
      'images': images,
      'coverImage': coverImage,
      'pricePerNight': pricePerNight,
      'currency': currency,
      'rating': rating,
      'reviewCount': reviewCount,
      'totalRooms': totalRooms,
      'maxGuests': maxGuests,
      'availableRoomTypes': availableRoomTypes?.map((r) => r.name).toList(),
      'amenities': amenities,
      'services': services,
      'hasWifi': hasWifi,
      'hasParking': hasParking,
      'hasPool': hasPool,
      'hasSpa': hasSpa,
      'hasRestaurant': hasRestaurant,
      'hasBar': hasBar,
      'hasGym': hasGym,
      'petsAllowed': petsAllowed,
      'hasAirConditioning': hasAirConditioning,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'cancellationPolicy': cancellationPolicy,
      'minimumStay': minimumStay,
      'nearbyAttractions': nearbyAttractions,
      'hasSpecialOffer': hasSpecialOffer,
      'discountPercentage': discountPercentage,
      'offerDescription': offerDescription,
    };
  }

  // Get mock accommodations
  static List<AccommodationData> getMockAccommodations() {
    return [
      AccommodationData(
        id: 'acc1',
        name: 'Serena Safari Lodge',
        operatorId: 'op2',
        operatorName: 'Serena Hotels & Resorts',
        type: AccommodationType.lodge,
        location: LatLng(-1.5056, 35.2669), // Maasai Mara
        city: 'Maasai Mara',
        region: 'Narok County',
        description: 'Luxurious safari lodge overlooking the Mara River. Watch wildlife from your private balcony while enjoying 5-star amenities.',
        tagline: 'Where Luxury Meets Wildlife',
        highlights: [
          'Prime game viewing location',
          'Infinity pool with savanna views',
          'Gourmet restaurant',
          'Guided safari tours included',
        ],
        images: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
          'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
        ],
        coverImage: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
        pricePerNight: 25000,
        rating: 4.9,
        reviewCount: 234,
        totalRooms: 42,
        maxGuests: 100,
        availableRoomTypes: [RoomType.double, RoomType.suite, RoomType.family],
        amenities: [
          'Free WiFi',
          'Swimming Pool',
          'Spa & Wellness',
          'Restaurant',
          'Bar',
          'Room Service',
          'Laundry',
          'Conference Facilities',
        ],
        services: [
          'Game Drives',
          'Airport Transfer',
          'Cultural Visits',
          'Hot Air Balloon Safaris',
        ],
        hasWifi: true,
        hasParking: true,
        hasPool: true,
        hasSpa: true,
        hasRestaurant: true,
        hasBar: true,
        hasAirConditioning: true,
        checkInTime: '2:00 PM',
        checkOutTime: '11:00 AM',
        cancellationPolicy: 'Free cancellation up to 7 days before check-in',
        minimumStay: 2,
        nearbyAttractions: [
          {'name': 'Mara River', 'distance': '500m'},
          {'name': 'Migration Crossing Point', 'distance': '2km'},
        ],
      ),
      AccommodationData(
        id: 'acc2',
        name: 'Maasai Mara Eco Camp',
        operatorId: 'op3',
        operatorName: 'Maasai Mara Eco Camp',
        type: AccommodationType.camp,
        location: LatLng(-1.4836, 35.1433),
        city: 'Maasai Mara',
        region: 'Narok County',
        description: 'Authentic tented camp experience. Sleep under canvas and wake to the sounds of the wild. Eco-friendly and community-focused.',
        tagline: 'Authentic Safari Camping',
        highlights: [
          'Eco-friendly tented accommodation',
          'Traditional Maasai cultural experiences',
          'Campfire dining under stars',
          'Supports local community',
        ],
        images: [
          'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800',
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800',
        ],
        coverImage: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800',
        pricePerNight: 8500,
        rating: 4.7,
        reviewCount: 156,
        totalRooms: 20,
        maxGuests: 50,
        availableRoomTypes: [RoomType.tent, RoomType.family],
        amenities: [
          'Shared WiFi',
          'Hot Showers',
          'Campfire',
          'Dining Tent',
          'Solar Power',
        ],
        services: [
          'Game Drives',
          'Maasai Village Visits',
          'Bush Walks',
          'Birdwatching',
        ],
        hasWifi: true,
        hasParking: true,
        hasRestaurant: true,
        checkInTime: '1:00 PM',
        checkOutTime: '10:00 AM',
        cancellationPolicy: 'Free cancellation up to 3 days before check-in',
        minimumStay: 1,
        hasSpecialOffer: true,
        discountPercentage: 20,
        offerDescription: '20% off for bookings of 3+ nights',
      ),
      AccommodationData(
        id: 'acc3',
        name: 'Diani Beach Resort',
        operatorId: 'op2',
        operatorName: 'Serena Hotels & Resorts',
        type: AccommodationType.resort,
        location: LatLng(-4.2945, 39.5773),
        city: 'Diani Beach',
        region: 'Kwale County',
        description: 'Beachfront paradise with white sand beaches and turquoise waters. All-inclusive luxury resort perfect for relaxation.',
        tagline: 'Your Tropical Paradise',
        highlights: [
          'Private beach access',
          'All-inclusive packages',
          'Water sports center',
          'Beachfront dining',
        ],
        images: [
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
          'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=800',
        ],
        coverImage: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
        pricePerNight: 18000,
        rating: 4.8,
        reviewCount: 432,
        totalRooms: 150,
        maxGuests: 400,
        availableRoomTypes: [
          RoomType.double,
          RoomType.suite,
          RoomType.family,
          RoomType.villa,
        ],
        amenities: [
          'Free WiFi',
          'Multiple Pools',
          'Spa & Wellness',
          'Multiple Restaurants',
          'Bars',
          'Fitness Center',
          'Kids Club',
          'Water Sports',
        ],
        services: [
          'Diving & Snorkeling',
          'Deep Sea Fishing',
          'Dhow Cruises',
          'Spa Treatments',
        ],
        hasWifi: true,
        hasParking: true,
        hasPool: true,
        hasSpa: true,
        hasRestaurant: true,
        hasBar: true,
        hasGym: true,
        hasAirConditioning: true,
        checkInTime: '3:00 PM',
        checkOutTime: '12:00 PM',
        cancellationPolicy: 'Free cancellation up to 14 days before check-in',
        minimumStay: 3,
      ),
    ];
  }
}
