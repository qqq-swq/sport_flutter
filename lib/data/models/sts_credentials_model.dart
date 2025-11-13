class StsCredentialsModel {
  final String accessKeyId;
  final String accessKeySecret;
  final String securityToken;
  final String bucket;
  final String region;
  final String expiration;

  StsCredentialsModel({
    required this.accessKeyId,
    required this.accessKeySecret,
    required this.securityToken,
    required this.bucket,
    required this.region,
    required this.expiration,
  });

  // THE FIX IS HERE: Reverted to parse a flat JSON object, matching the actual server response.
  factory StsCredentialsModel.fromJson(Map<String, dynamic> json) {
    return StsCredentialsModel(
      accessKeyId: json['accessKeyId'] as String,
      accessKeySecret: json['accessKeySecret'] as String,
      securityToken: json['securityToken'] as String,
      bucket: json['bucket'] as String,
      region: json['region'] as String,
      expiration: json['expiration'] as String,
    );
  }
}