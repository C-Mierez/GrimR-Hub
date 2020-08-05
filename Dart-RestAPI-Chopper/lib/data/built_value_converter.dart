import 'package:chopper/chopper.dart';
import 'package:dart_rest_api_chopper/model/built_post.dart';
import 'package:dart_rest_api_chopper/model/serializers.dart';
import 'package:built_collection/built_collection.dart';

class BuiltValueConverter extends JsonConverter {
  @override
  Request convertRequest(Request request) {
    return super.convertRequest(request.copyWith(
        body: serializers.serializeWith(
      // This runtimeType will be a BuiltPost
      serializers.serializerForType(request.body.runtimeType),
      request.body,
    )));
  }

  @override
  Response<BodyType> convertResponse<BodyType, SingleItemType>(
    Response response,
  ) {
    final Response dynamicResponse = super.convertResponse(response);
    final BodyType customBody =
        _convertToCustomObject<SingleItemType>(dynamicResponse.body);
    return dynamicResponse.copyWith<BodyType>(body: customBody);
  }

  dynamic _convertToCustomObject<SingleItemType>(dynamic element) {
    if (element is SingleItemType) return element;
    if (element is List)
      return _deserializedListOf<SingleItemType>(element);
    else
      return _deserialize<SingleItemType>(element);
  }

  BuiltList<SingleItemType> _deserialize<SingleItemType>(
      Map<String, dynamic> value) {
    return serializers.deserializeWith(
      serializers.serializerForType(SingleItemType),
      value,
    );
  }

  BuiltList<SingleItemType> _deserializedListOf<SingleItemType>(
    List dynamicList,
  ) {
    return BuiltList<SingleItemType>(dynamicList.map(
      (element) => _deserialize<SingleItemType>(element),
    ));
  }
}
