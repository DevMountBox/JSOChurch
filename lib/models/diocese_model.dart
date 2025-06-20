class DioceseModel {
  final String dioceseId;
  final String dioceseName;
  final String phoneNumber;
  final String dioceseMetropolitan;
  final String churchCount;
  final String address;
  final String image;
  final List<String> regions;
  DioceseModel({
    required this.dioceseId,
    required this.dioceseName,
    required this.phoneNumber,
    required this.dioceseMetropolitan,
    required this.churchCount,
    required this.address,
    required this.image,
    required this.regions,
  });

  factory DioceseModel.fromMap(Map<String, dynamic> map) {
    return DioceseModel(
      dioceseId: map['dioceseId'] as String,
      dioceseName: map['dioceseName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      dioceseMetropolitan: map['dioceseMetropolitan'] as String,
      churchCount: map['churchCount'] as String,
      address: map['address'] as String,
      image: map['image'] as String,
      regions: map['region'] as List<String>,
    );
  }

  // Method to convert DioceseModel to a map (e.g., for uploading to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'dioceseId': dioceseId,
      'dioceseName': dioceseName,
      'phoneNumber': phoneNumber,
      'dioceseMetropolitan': dioceseMetropolitan,
      'churchCount': churchCount,
      'address': address,
      'image': image,
    };
  }
}
