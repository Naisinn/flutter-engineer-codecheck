import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repository.dart';

class GitHubApiService {
  static const String baseUrl = 'https://api.github.com';

  Future<List<Repository>> searchRepositories(String query) async {
    final url = Uri.parse('$baseUrl/search/repositories?q=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List items = data['items'] as List;
      return items.map((json) => Repository.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
