import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../services/github_api_service.dart';

class RepositoryProvider extends ChangeNotifier {
  final GitHubApiService _apiService = GitHubApiService();
  List<Repository> _repositories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Repository> get repositories => _repositories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> search(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _repositories = await _apiService.searchRepositories(query);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
