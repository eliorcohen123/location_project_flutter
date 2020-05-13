import 'package:flutter/foundation.dart';

abstract class UseCaseCoreLocation<ParamsLocation> {
  Future callLocation({@required ParamsLocation paramsLocation});
}