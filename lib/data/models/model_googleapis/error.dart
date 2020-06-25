class Error {
  String errorMessage;

  Error.fromJson(Map<String, dynamic> json) {
    this.errorMessage = json['error_message'];
  }
}
