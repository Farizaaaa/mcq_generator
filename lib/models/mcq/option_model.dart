class McqOptionModel {
  final String key;
  final String value;
  McqOptionModel({
    required this.key,
    required this.value,
  });
  // Factory constructor to create an Option object from JSON
  factory McqOptionModel.fromJson(Map<String, dynamic> json) {
    return McqOptionModel(
      key: json['key'],
      value: json['value'],
    );
  }
  // Method to convert Option object to JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}