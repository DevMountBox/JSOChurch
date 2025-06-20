class DioceseDetailModel {
  final String dioceseId;
  final String dioceseName;
  final List<String> region;
  final String phoneNumber;
  final String website;
  final String noOfChurches;
  final String address;
  final String dioceseMetropolitan;
  final String dioceseMetropolitanPhone;
  final String dioceseMetropolitanId;
  final String dioceseSecretary;
  final String dioceseSecretaryPhone;
  final String dioceseSecretaryId;
   String image;

  DioceseDetailModel({
    required this.dioceseId,
    required this.dioceseName,
    required this.region,
    required this.phoneNumber,
    required this.website,
    required this.noOfChurches,
    required this.address,
    required this.dioceseMetropolitan,
    required this.dioceseMetropolitanPhone,
    required this.dioceseMetropolitanId,
    required this.dioceseSecretary,
    required this.dioceseSecretaryPhone,
    required this.dioceseSecretaryId,
    required this.image,
  });


}
