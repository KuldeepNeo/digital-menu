import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/special.dart';

part 'special_model.freezed.dart';
part 'special_model.g.dart';

@freezed
abstract class SpecialModel with _$SpecialModel {
  const factory SpecialModel({
    required String id,
    required String dishId,
    required String title,
    required int expiresAt,
  }) = _SpecialModel;

  factory SpecialModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialModelFromJson(json);

  factory SpecialModel.fromEntity(Special entity) => SpecialModel(
        id: entity.id,
        dishId: entity.dishId,
        title: entity.title,
        expiresAt: entity.expiresAt,
      );

  const SpecialModel._();

  Special toEntity() => Special(
        id: id,
        dishId: dishId,
        title: title,
        expiresAt: expiresAt,
      );
}
