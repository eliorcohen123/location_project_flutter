abstract class LocationRepoApi {
  Future getLocationJson(
    double latitude,
    double longitude,
    String open,
    String type,
    int valueRadiusText,
    String text,
  );
}
