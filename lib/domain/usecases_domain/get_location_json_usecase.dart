import 'package:equatable/equatable.dart';
import 'package:locationprojectflutter/core/usecases_core/usecase_core_location.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:meta/meta.dart';

class GetLocationJsonUsecase implements UseCaseCoreLocation<ParamsLocation> {
  LocationRepositoryImpl locationRepositoryImpl = LocationRepositoryImpl();

  @override
  Future callLocation({@required ParamsLocation paramsLocation}) async {
    return await locationRepositoryImpl.getLocationJson(paramsLocation.latitude,
        paramsLocation.longitude, paramsLocation.open, paramsLocation.type, paramsLocation.valueRadiusText, paramsLocation.text);
  }
}

class ParamsLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String open;
  final String type;
  final int valueRadiusText;
  final String text;

  ParamsLocation({
    @required this.latitude,
    @required this.longitude,
    @required this.open,
    @required this.type,
    @required this.valueRadiusText,
    @required this.text,
  });

  @override
  List<Object> get props => [latitude, longitude, open, type, valueRadiusText, text];
}
