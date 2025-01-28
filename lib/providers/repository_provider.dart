// providers/repository_provider.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../services/github_api_service.dart';

/// カスタム例外の種類を保持
enum RepositoryErrorType {
  noInternet,
  notFound,
  serverError,
  rateLimit,
  timeout,
  noResults,
  unknown,
}

/// リポジトリの検索状態を管理するプロバイダ
class RepositoryProvider extends ChangeNotifier {
  final GitHubApiService _apiService = GitHubApiService();

  List<Repository> _repositories = [];
  bool _isLoading = false;
  RepositoryErrorType? _errorType;

  List<Repository> get repositories => _repositories;
  bool get isLoading => _isLoading;
  RepositoryErrorType? get errorType => _errorType;

  /// 指定された条件でGitHubからリポジトリを検索するメソッド
  Future<void> search(
      String query, { // 変更: BuildContext を削除
        String? owner,
        String? language,
        String? license, // ライセンスフィルタを追加
        String? sort,    // ソート基準を追加
        String? order,   // ソート順を追加
      }) async {
    _isLoading = true;
    _errorType = null;
    notifyListeners();  // 状態の変更を通知

    try {
      // サービスを用いてリポジトリ検索を実行
      _repositories = await _apiService.searchRepositories(
        query,
        owner: owner,
        language: language,
        license: license, // ライセンスフィルタを渡す
        sort: sort,       // ソート基準を渡す
        order: order,     // ソート順を渡す
      );

      // 検索結果が0件の場合はエラーとして扱う
      if (_repositories.isEmpty) {
        _errorType = RepositoryErrorType.noResults;
      }
    } catch (error) {
      // カスタム例外をチェックしてエラーメッセージのタイプを設定
      if (error is GitHubApiError) {
        switch (error.type) {
          case GitHubApiErrorType.noInternet:
            _errorType = RepositoryErrorType.noInternet;
            break;
          case GitHubApiErrorType.notFound:
            _errorType = RepositoryErrorType.notFound;
            break;
          case GitHubApiErrorType.serverError:
            _errorType = RepositoryErrorType.serverError;
            break;
          case GitHubApiErrorType.rateLimit:
            _errorType = RepositoryErrorType.rateLimit;
            break;
          case GitHubApiErrorType.timeout:
            _errorType = RepositoryErrorType.timeout;
            break;
          case GitHubApiErrorType.unknown:
            _errorType = RepositoryErrorType.unknown;
            break;
        }
      } else {
        _errorType = RepositoryErrorType.unknown;
      }
    }

    _isLoading = false;
    notifyListeners();  // 状態の変更を通知
  }
}
