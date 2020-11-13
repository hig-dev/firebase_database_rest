import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_result.freezed.dart';

@freezed
abstract class TransactionResult<T> with _$TransactionResult<T> {
  const factory TransactionResult.update(T data) = _Update;
  const factory TransactionResult.delete() = _Delete;
  const factory TransactionResult.abort() = _Abort;
}
