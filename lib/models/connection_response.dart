import 'dart:convert';

class ConnectionResponse {
  final String? error;
  final bool connected;
  ConnectionResponse({
    this.error,
    required this.connected,
  });

  ConnectionResponse copyWith({
    String? error,
    bool? connected,
  }) {
    return ConnectionResponse(
      error: error ?? this.error,
      connected: connected ?? this.connected,
    );
  }

  @override
  String toString() =>
      'ConnectionResponse(error: $error, connected: $connected)';

  @override
  bool operator ==(covariant ConnectionResponse other) {
    if (identical(this, other)) return true;

    return other.error == error && other.connected == connected;
  }

  @override
  int get hashCode => error.hashCode ^ connected.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'connected': connected,
    };
  }

  factory ConnectionResponse.fromMap(Map<String, dynamic> map) {
    return ConnectionResponse(
      error: map['error'] != null ? map['error'] as String : null,
      connected: map['connected'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConnectionResponse.fromJson(String source) =>
      ConnectionResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
