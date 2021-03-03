// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_response.freezed.dart';
part 'post_response.g.dart';

/// A post response, returned by the server for POST requests
@freezed
class PostResponse with _$PostResponse {
  /// Default constructor
  const factory PostResponse(
    /// The name of the newly created entry in firebase
    String name,
  ) = _PostResponse;

  /// @nodoc
  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}
