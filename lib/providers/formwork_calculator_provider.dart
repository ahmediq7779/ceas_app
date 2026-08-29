import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/formwork_earthwork_model.dart';
import '../services/formwork_service.dart';
import 'rate_settings_provider.dart';

class FormworkState {
  final FormworkElementType elementType;
  final double lengthM;
  final double widthM;
  final double heightOrDepthM;
  final int count;
  final int reuseCycles;
  final FormworkCalculationResult? result;

  const FormworkState({
    this.elementType = FormworkElementType.slab,
    this.lengthM = 12.0,
    this.widthM = 8.0,
    this.heightOrDepthM = 0.20,
    this.count = 1,
    this.reuseCycles = 4,
    this.result,
  });

  FormworkState copyWith({
    FormworkElementType? elementType,
    double? lengthM,
    double? widthM,
    double? heightOrDepthM,
    int? count,
    int? reuseCycles,
    FormworkCalculationResult? result,
  }) {
    return FormworkState(
      elementType: elementType ?? this.elementType,
      lengthM: lengthM ?? this.lengthM,
      widthM: widthM ?? this.widthM,
      heightOrDepthM: heightOrDepthM ?? this.heightOrDepthM,
      count: count ?? this.count,
      reuseCycles: reuseCycles ?? this.reuseCycles,
      result: result ?? this.result,
    );
  }
}

class FormworkNotifier extends StateNotifier<FormworkState> {
  final Ref _ref;

  FormworkNotifier(this._ref) : super(const FormworkState()) {
    calculate();
  }

  void updateElementType(FormworkElementType type) {
    state = state.copyWith(elementType: type);
    calculate();
  }

  void updateInputs({
    double? lengthM,
    double? widthM,
    double? heightOrDepthM,
    int? count,
    int? reuseCycles,
  }) {
    state = state.copyWith(
      lengthM: lengthM,
      widthM: widthM,
      heightOrDepthM: heightOrDepthM,
      count: count,
      reuseCycles: reuseCycles,
    );
    calculate();
  }

  void calculate() {
    final rates = _ref.read(rateSettingsProvider);
    final result = FormworkService.calculateFormwork(
      elementType: state.elementType,
      lengthM: state.lengthM,
      widthM: state.widthM,
      heightOrDepthM: state.heightOrDepthM,
      count: state.count,
      reuseCycles: state.reuseCycles,
      rates: rates,
    );
    state = state.copyWith(result: result);
  }
}

final formworkProvider =
    StateNotifierProvider<FormworkNotifier, FormworkState>((ref) {
  return FormworkNotifier(ref);
});
