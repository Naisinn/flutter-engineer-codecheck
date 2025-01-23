// providers/repository_provider.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../services/github_api_service.dart';

/// リポジトリの検索状態を管理するプロバイダ
class RepositoryProvider extends ChangeNotifier {
  final GitHubApiService _apiService = GitHubApiService();

  List<Repository> _repositories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Repository> get repositories => _repositories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 指定された条件でGitHubからリポジトリを検索するメソッド
  Future<void> search(
      String query, {
        String? owner,
        String? language,
        String? license, // ライセンスフィルタを追加
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();  // 状態の変更を通知

    try {
      // サービスを用いてリポジトリ検索を実行
      _repositories = await _apiService.searchRepositories(
        query,
        owner: owner,
        language: language,
        license: license, // ライセンスフィルタを渡す
      );
    } catch (e) {
      // エラーが発生した場合、エラーメッセージを設定
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();  // 状態の変更を通知
  }
}
