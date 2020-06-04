class Photo {
  String photoReference;

  Photo({this.photoReference});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      photoReference: json['photo_reference'],
    );
  }
}
