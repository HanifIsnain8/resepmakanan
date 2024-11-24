import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resepmakanan/models/response_model.dart';
import 'package:resepmakanan/services/session_service.dart';

const String baseUrl = 'https://recipe.incube.id/api';

class AuthService {
  final SessionService _sessionService = SessionService();
  
  Future<Map<String,dynamic>> register(String name, String email, String password) async{
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {'name':name, 'email':email, 'password':password}
      );
    
    if (response.statusCode==201) {
      ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      await _sessionService.saveToken(res.data["token"]);
      await _sessionService.saveUser(
        res.data["user"]["id"].toString(), 
        res.data["user"]["name"], 
        res.data["user"]["email"]
        );
      return {"status":true, "message":res.message};
    } else if (response.statusCode==422) {
       ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
        Map<String,dynamic> err = res.errors as Map<String,dynamic>;
      return {"status":false, "message":res.message, "error":err};
    } else {
      throw Exception("Failed to register user");
    }
  }


  Future<Map<String,dynamic>> login(String email, String password) async{
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email':email, 'password':password}
      );
    
    if (response.statusCode==200) {
      ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      await _sessionService.saveToken(res.data["token"]);
      await _sessionService.saveUser(
        res.data["user"]["id"].toString(), 
        res.data["user"]["name"], 
        res.data["user"]["email"]
        );
      return {"status":true, "message":res.message};
    } else if (response.statusCode==401) {
       ResponseModel res = ResponseModel.formJson(jsonDecode(response.body));
      return {"status":false, "message":res.message};
    } else {
      throw Exception("Failed to login");
    }
  }
}