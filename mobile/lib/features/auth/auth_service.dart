import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000"; // GANTI DENGAN IP/PC KAMU

  Future<bool> registerFull({
    required String name,
    required String phone,
    required String storeName,
    required String address,
    required String email,
    required String username,
    required String password,
    required String passwordConfirm,
    File? logo,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/auth/register-full/'),
      );

      request.fields['name'] = name;
      request.fields['phone_number'] = phone;
      request.fields['store_name'] = storeName;
      request.fields['address'] = address;
      request.fields['email'] = email;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['password_confirm'] = passwordConfirm;

      if (logo != null) {
        request.files.add(await http.MultipartFile.fromPath('logo', logo.path));
      }

      final response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        await prefs.setString('refresh_token', data['refresh']);
        return data;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}