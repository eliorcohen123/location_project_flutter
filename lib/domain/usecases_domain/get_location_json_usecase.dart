import 'package:equatable/equatable.dart';
import 'package:locationprojectflutter/core/usecases_core/usecase_core.dart';
import 'package:locationprojectflutter/data/repository_impl/location_repo_impl.dart';
import 'package:meta/meta.dart';

class GetLocationJsonUsecase implements UseCaseCore<ParamsLocation> {
  LocationRepositoryImpl locationRepositoryImpl = LocationRepositoryImpl();

  GetLocationJsonUsecase();

  @override
  Future call({@required ParamsLocation paramsLocation}) async {
    return await locationRepositoryImpl.getLocationJson(paramsLocation.latitude,
        paramsLocation.longitude, paramsLocation.type, paramsLocation.valueRadiusText, paramsLocation.text);
  }
}

class ParamsLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String type;
  final int valueRadiusText;
  final String text;

  ParamsLocation({
    @required this.latitude,
    @required this.longitude,
    @required this.type,
    @required this.valueRadiusText,
    @required this.text,
  });

  @override
  List<Object> get props => [latitude, longitude, type, valueRadiusText, text];
}
