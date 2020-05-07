import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class UseCaseCore<Params> {
  Future call({@required Params paramsLocation});
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
