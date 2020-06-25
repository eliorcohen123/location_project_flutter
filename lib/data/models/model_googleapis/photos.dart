class Photos {
  String photo_reference;

  Photos.fromJson(Map<String, dynamic> json) {
    this.photo_reference = json['photo_reference'];
  }
}
