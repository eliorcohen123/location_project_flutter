import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class UseCaseCore<ParamsLocation> {
  Future callLocation({@required ParamsLocation paramsLocation});
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
