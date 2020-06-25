class Location {
  double lat;
  double lng;

  Location.fromJson(Map<String, dynamic> json) {
    this.lat = json['lat'];
    this.lng = json['lng'];
  }
}
