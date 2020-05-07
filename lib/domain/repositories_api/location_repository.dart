abstract class LocationRepository {
  Future getLocationJson(double latitude, double longitude, String type,
      int valueRadiusText, String text);
}
