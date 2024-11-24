class ResponseModel {
  String status;
  String message;
  dynamic data;
  dynamic errors;

  ResponseModel({
    required this.status,
    required this.message,
    this.data,
    this.errors
  });

  factory ResponseModel.formJson(Map<String, dynamic> json){
    return ResponseModel(
      status: json["status"], 
      message:  json["message"],
      data:  json["data"],
      errors:  json["errors"],
      );
  }
}