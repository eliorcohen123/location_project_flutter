class OpeningHours {
  bool open_now;

  OpeningHours.fromJson(Map<String, dynamic> json) {
    this.open_now = json['open_now'];
  }
}
