class Geo {
  final String city;
  final String region;

  Geo({
    required this.city,
    required this.region,
  });

  factory Geo.fromMap(Map<String, dynamic> map) {
    return Geo(
      city: map['city'] as String ?? '',
      region: map['region'] as String ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'region': region,
    };
  }
}
