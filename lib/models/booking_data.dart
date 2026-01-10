import 'package:latlong2/latlong.dart';

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
  refunded,
}

enum PaymentStatus {
  pending,
  partial,
  completed,
  failed,
  refunded,
}

enum PaymentMethod {
  mpesa,
  card,
  bankTransfer,
  cash,
}

class BookingData {
  // Tour Information
  String? tourId;
  String? tourName;
  String? tourImage;
  double? pricePerPerson;
  String? operatorName;
  String? operatorId;

  // Booking Details
  DateTime? bookingDate;
  DateTime? tourDate;
  int adults;
  int children;
  String? specialRequests;

  // Participant Information
  List<ParticipantInfo> participants;

  // Pricing
  double? basePrice;
  double? childDiscount; // Percentage
  double? taxRate; // Percentage
  double? serviceFee;
  double? discount; // Amount
  String? promoCode;

  // Payment Information
  PaymentMethod? paymentMethod;
  PaymentOption? paymentOption; // Full or Partial
  double? depositPercentage; // For partial payment
  double? amountPaid;
  double? amountDue;
  List<PaymentTransaction> transactions;

  // Status
  BookingStatus status;
  PaymentStatus paymentStatus;

  // Metadata
  String? bookingId;
  String? confirmationCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userId;

  BookingData({
    this.tourId,
    this.tourName,
    this.tourImage,
    this.pricePerPerson,
    this.operatorName,
    this.operatorId,
    this.bookingDate,
    this.tourDate,
    this.adults = 1,
    this.children = 0,
    this.specialRequests,
    this.participants = const [],
    this.basePrice,
    this.childDiscount = 20.0, // Default 20% discount for children
    this.taxRate = 16.0, // Default 16% VAT
    this.serviceFee,
    this.discount,
    this.promoCode,
    this.paymentMethod,
    this.paymentOption,
    this.depositPercentage = 30.0, // Default 30% deposit
    this.amountPaid = 0,
    this.amountDue,
    this.transactions = const [],
    this.status = BookingStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.bookingId,
    this.confirmationCode,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  // Calculate total participants
  int get totalParticipants => adults + children;

  // Calculate subtotal before discounts and taxes
  double get subtotal {
    if (pricePerPerson == null) return 0;
    final adultTotal = adults * pricePerPerson!;
    final childPrice = pricePerPerson! * (1 - (childDiscount ?? 0) / 100);
    final childTotal = children * childPrice;
    return adultTotal + childTotal;
  }

  // Calculate discount amount
  double get discountAmount => discount ?? 0;

  // Calculate tax amount
  double get taxAmount {
    final taxableAmount = subtotal - discountAmount;
    return taxableAmount * ((taxRate ?? 0) / 100);
  }

  // Calculate service fee amount
  double get serviceFeeAmount => serviceFee ?? (subtotal * 0.05); // Default 5%

  // Calculate total amount
  double get totalAmount {
    return subtotal - discountAmount + taxAmount + serviceFeeAmount;
  }

  // Calculate deposit amount for partial payment
  double get depositAmount {
    if (paymentOption == PaymentOption.partial) {
      return totalAmount * ((depositPercentage ?? 30) / 100);
    }
    return totalAmount;
  }

  // Calculate remaining balance
  double get remainingBalance {
    return totalAmount - (amountPaid ?? 0);
  }

  // Check if booking is fully paid
  bool get isFullyPaid => remainingBalance <= 0;

  // Check if booking is valid
  bool get isValid {
    return tourId != null &&
        tourDate != null &&
        totalParticipants > 0 &&
        participants.length == totalParticipants &&
        paymentMethod != null &&
        paymentOption != null;
  }

  Map<String, dynamic> toJson() {
    return {
      'tourId': tourId,
      'tourName': tourName,
      'tourImage': tourImage,
      'pricePerPerson': pricePerPerson,
      'operatorName': operatorName,
      'operatorId': operatorId,
      'bookingDate': bookingDate?.toIso8601String(),
      'tourDate': tourDate?.toIso8601String(),
      'adults': adults,
      'children': children,
      'specialRequests': specialRequests,
      'participants': participants.map((p) => p.toJson()).toList(),
      'basePrice': basePrice,
      'childDiscount': childDiscount,
      'taxRate': taxRate,
      'serviceFee': serviceFee,
      'discount': discount,
      'promoCode': promoCode,
      'paymentMethod': paymentMethod?.name,
      'paymentOption': paymentOption?.name,
      'depositPercentage': depositPercentage,
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'bookingId': bookingId,
      'confirmationCode': confirmationCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'userId': userId,
    };
  }
}

enum PaymentOption {
  full,
  partial,
}

class ParticipantInfo {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  DateTime? dateOfBirth;
  String? nationality;
  String? idNumber;
  bool isChild;

  ParticipantInfo({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.nationality,
    this.idNumber,
    this.isChild = false,
  });

  bool get isValid {
    return firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty;
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'nationality': nationality,
      'idNumber': idNumber,
      'isChild': isChild,
    };
  }

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    return ParticipantInfo(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      nationality: json['nationality'],
      idNumber: json['idNumber'],
      isChild: json['isChild'] ?? false,
    );
  }
}

class PaymentTransaction {
  String? transactionId;
  DateTime? timestamp;
  double amount;
  PaymentMethod method;
  PaymentStatus status;
  String? referenceNumber;
  String? phoneNumber; // For M-Pesa
  String? cardLast4; // For card payments
  String? failureReason;

  PaymentTransaction({
    this.transactionId,
    this.timestamp,
    required this.amount,
    required this.method,
    this.status = PaymentStatus.pending,
    this.referenceNumber,
    this.phoneNumber,
    this.cardLast4,
    this.failureReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'timestamp': timestamp?.toIso8601String(),
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'referenceNumber': referenceNumber,
      'phoneNumber': phoneNumber,
      'cardLast4': cardLast4,
      'failureReason': failureReason,
    };
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      transactionId: json['transactionId'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      amount: json['amount']?.toDouble() ?? 0.0,
      method: PaymentMethod.values.firstWhere(
        (m) => m.name == json['method'],
        orElse: () => PaymentMethod.mpesa,
      ),
      status: PaymentStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      referenceNumber: json['referenceNumber'],
      phoneNumber: json['phoneNumber'],
      cardLast4: json['cardLast4'],
      failureReason: json['failureReason'],
    );
  }
}
