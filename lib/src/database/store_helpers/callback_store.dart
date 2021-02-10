import 'package:meta/meta.dart';

import '../../rest/rest_api.dart';
import '../store.dart';

@internal
class CallbackFirebaseStore<T> extends FirebaseStore<T> {
  final DataFromJsonCallback<T> onDataFromJson;
  final DataToJsonCallback<T> onDataToJson;
  final PatchDataCallback<T> onPatchData;

  CallbackFirebaseStore({
    required FirebaseStore<dynamic> parent,
    required String path,
    required this.onDataFromJson,
    required this.onDataToJson,
    required this.onPatchData,
  }) : super(
          parent: parent,
          path: path,
        );

  CallbackFirebaseStore.api({
    required RestApi restApi,
    required List<String> subPaths,
    required this.onDataFromJson,
    required this.onDataToJson,
    required this.onPatchData,
  }) : super.api(
          restApi: restApi,
          subPaths: subPaths,
        );

  @override
  T dataFromJson(dynamic? json) => onDataFromJson(json);

  @override
  dynamic? dataToJson(T data) => onDataToJson(data);

  @override
  T patchData(T data, Map<String, dynamic> updatedFields) =>
      onPatchData(data, updatedFields);
}
