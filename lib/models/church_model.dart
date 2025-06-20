class ChurchModel {
  final String churchId;
  final String churchName;
  final String diocese;
  final String dioceseId;
  final String phoneNumber;
  final String address;
  final String primaryVicar;
  final String image;
  final String region;

  ChurchModel({
    required this.churchId,
    required this.churchName,
    required this.diocese,
    required this.dioceseId,
    required this.phoneNumber,
    required this.address,
    required this.primaryVicar,
    required this.image,
    required this.region,
  });

  // Method to convert a JSON map to a ChurchModel instance
  factory ChurchModel.fromJson(Map<String, dynamic> json) {
    return ChurchModel(
      churchId: json['churchId'] ?? '',
      churchName: json['churchName'] ?? '',
      diocese: json['diocese'] ?? '',
      dioceseId: json['dioceseId'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      primaryVicar: json['primaryVicar'] ?? '',
      image: json['image'] ?? '',
      region: json['region'] ?? '',
    );
  }

  // Method to convert a ChurchModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'churchId': churchId,
      'churchName': churchName,
      'diocese': diocese,
      'dioceseId': dioceseId,
      'phoneNumber': phoneNumber,
      'address': address,
      'primaryVicar': primaryVicar,
      'image': image,
      'region': region,
    };
  }
}
