class Photo {
  String photoReference;

  Photo.fromJson(Map<String, dynamic> json) {
    this.photoReference = json['photo_reference'];
  }
}
