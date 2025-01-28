// providers/repository_provider.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../services/github_api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  /// contextを受け取ってローカライズ用メッセージを取得できるよう変更
  Future<void> search(
      BuildContext context,
      String query, {
        String? owner,
        String? language,
        String? license, // ライセンスフィルタを追加
        String? sort,    // ソート基準を追加
        String? order,   // ソート順を追加
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
        sort: sort,       // ソート基準を渡す
        order: order,     // ソート順を渡す
      );
    } catch (error) {
      // カスタム例外をチェックしてローカライズ済みメッセージを設定
      final loc = AppLocalizations.of(context)!;
      _errorMessage = _apiService.convertErrorToMessage(error, loc);
    }

    _isLoading = false;
    notifyListeners();  // 状態の変更を通知
  }
}
