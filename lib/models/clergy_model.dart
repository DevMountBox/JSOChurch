
class ClergyModel {
  final String fatherId;
  final String type;
  final String fatherName;
  final String vicarAt;
  final String address;
  final String image;
  final String phoneNumber;
  final int status;
  final int priority;

  ClergyModel({
    required this.fatherId,
    required this.type,
    required this.fatherName,
    required this.vicarAt,
    required this.address,
    required this.image,
    required this.phoneNumber,
    required this.status,
    required this.priority,
  });

  // Factory method for creating a ClergyModel from a JSON object
  factory ClergyModel.fromJson(Map<String, dynamic> json) {
    return ClergyModel(
      fatherId: json['fatherId'] as String,
      type: json['type'] as String,
      fatherName: json['fatherName'] as String,
      vicarAt: json['vicarAt'] as String,
      address: json['address'] as String,
      image: json['image'] as String,
      phoneNumber: json['phoneNumber'] as String,
      status: json['status'] as int,
      priority: json['priority'] as int,
    );
  }

  // Method to convert a ClergyModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fatherId': fatherId,
      'type': type,
      'fatherName': fatherName,
      'vicarAt': vicarAt,
      'address': address,
      'image': image,
      'phoneNumber': phoneNumber,
      'status': status,
      'priority': priority,
    };
  }
  factory ClergyModel.empty() {
    return ClergyModel(
      fatherId: "",
      type: "",
      fatherName: "",
      vicarAt: "",
      address: "",
      image: "",
      phoneNumber: "",
      status: 0,
      priority: 0,
    );
  }
}
