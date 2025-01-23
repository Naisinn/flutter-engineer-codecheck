// services/github_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repository.dart';

/// GitHub APIとの通信を行うサービスクラス
class GitHubApiService {
  static const String baseUrl = 'https://api.github.com';

  /// キーワード、オーナー、言語、ライセンスを指定してリポジトリを検索するメソッド
  Future<List<Repository>> searchRepositories(
      String query, {
        String? owner,
        String? language,
        String? license, // ライセンスパラメータを追加
      }) async {
    // オーナー名が指定されていればクエリに追加
    final ownerQuery = (owner != null && owner.isNotEmpty) ? 'user:$owner' : '';
    // 言語が指定されていればクエリに追加
    final languageQuery = (language != null && language.isNotEmpty) ? 'language:$language' : '';
    // ライセンスが指定されていればクエリに追加
    final licenseQuery = (license != null && license.isNotEmpty) ? 'license:$license' : '';

    // 有効なクエリ部分を結合して完全な検索クエリを構築
    final combinedQuery =
    [query, ownerQuery, languageQuery, licenseQuery]
        .where((element) => element.isNotEmpty)
        .join(' ');

    // 検索用のURLを生成
    final url = Uri.parse('$baseUrl/search/repositories?q=$combinedQuery');

    // HTTP GETリクエストを送信
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // レスポンスのJSONをデコードし、リポジトリリストを生成
      final data = json.decode(response.body);
      List items = data['items'] as List;
      return items.map((json) => Repository.fromJson(json)).toList();
    } else {
      // エラー時は例外を投げる
      throw Exception('Failed to load repositories');
    }
  }
}
