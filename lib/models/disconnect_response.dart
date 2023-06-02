import 'dart:convert';

class DisconnectResponse {
  final String? error;
  final bool disconnected;

  DisconnectResponse({
    this.error,
    required this.disconnected,
  });

  DisconnectResponse copyWith({
    String? error,
    bool? disconnected,
  }) {
    return DisconnectResponse(
      error: error ?? this.error,
      disconnected: disconnected ?? this.disconnected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'disconnected': disconnected,
    };
  }

  factory DisconnectResponse.fromMap(Map<String, dynamic> map) {
    return DisconnectResponse(
      error: map['error'] != null ? map['error'] as String : null,
      disconnected: map['disconnected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory DisconnectResponse.fromJson(String source) =>
      DisconnectResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DisconnectResponse(error: $error, disconnected: $disconnected)';

  @override
  bool operator ==(covariant DisconnectResponse other) {
    if (identical(this, other)) return true;

    return other.error == error && other.disconnected == disconnected;
  }

  @override
  int get hashCode => error.hashCode ^ disconnected.hashCode;
}
