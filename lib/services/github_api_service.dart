//services/github_api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// カスタム例外の種類
enum GitHubApiErrorType {
  noInternet,
  notFound,
  serverError,
  rateLimit,
  timeout,
  unknown,
}

/// カスタム例外クラス
class GitHubApiError implements Exception {
  final GitHubApiErrorType type;
  final String? message;

  GitHubApiError({required this.type, this.message});

  @override
  String toString() {
    return 'GitHubApiError(type: $type, message: $message)';
  }
}

/// GitHub APIとの通信を行うサービスクラス
class GitHubApiService {
  static const String baseUrl = 'https://api.github.com';

  /// キーワード、オーナー、言語、ライセンス、ソート基準、ソート順を指定してリポジトリを検索するメソッド
  Future<List<Repository>> searchRepositories(
      String query, {
        String? owner,
        String? language,
        String? license,
        String? sort,
        String? order,
      }) async {
    try {
      // オーナー名が指定されていればクエリに追加
      final ownerQuery = (owner != null && owner.isNotEmpty) ? 'user:$owner' : '';
      // 言語が指定されていればクエリに追加
      final languageQuery = (language != null && language.isNotEmpty) ? 'language:$language' : '';
      // ライセンスが指定されていればクエリに追加
      final licenseQuery = (license != null && license.isNotEmpty) ? 'license:$license' : '';

      // 有効なクエリ部分を結合して完全な検索クエリを構築
      final combinedQuery =
      [query, ownerQuery, languageQuery, licenseQuery].where((element) => element.isNotEmpty).join(' ');

      // 検索用のURLを生成
      final url = Uri.parse(
        '$baseUrl/search/repositories?q=$combinedQuery${sort != null ? '&sort=$sort' : ''}${order != null ? '&order=$order' : ''}',
      );

      // HTTP GETリクエストを送信 (タイムアウトを適宜設定)
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      // ステータスコードごとの処理
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List items = data['items'] as List;
        return items.map((json) => Repository.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw GitHubApiError(type: GitHubApiErrorType.notFound);
      } else if (response.statusCode == 403) {
        // Rate Limitチェック
        if (response.headers['x-ratelimit-remaining'] == '0') {
          throw GitHubApiError(type: GitHubApiErrorType.rateLimit);
        } else {
          throw GitHubApiError(type: GitHubApiErrorType.serverError);
        }
      } else if (response.statusCode >= 500) {
        throw GitHubApiError(type: GitHubApiErrorType.serverError);
      } else {
        // その他のステータス
        throw GitHubApiError(type: GitHubApiErrorType.unknown, message: 'Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw GitHubApiError(type: GitHubApiErrorType.noInternet);
    } on TimeoutException {
      throw GitHubApiError(type: GitHubApiErrorType.timeout);
    } catch (e) {
      throw GitHubApiError(type: GitHubApiErrorType.unknown, message: e.toString());
    }
  }

  /// 指定したリポジトリのREADMEを取得するメソッド
  Future<String> fetchReadme(String owner, String repo) async {
    final url = Uri.parse('$baseUrl/repos/$owner/$repo/readme');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // content フィールドがBase64エンコードされたREADMEの内容
        String base64Content = data['content'];

        // 改行文字を削除
        base64Content = base64Content.replaceAll('\n', '');

        // Base64をデコードしてUTF-8文字列に変換
        final decodedBytes = base64.decode(base64Content);
        final readmeContent = utf8.decode(decodedBytes);

        return readmeContent;
      } else if (response.statusCode == 404) {
        // READMEが無い場合など
        return '';
      } else if (response.statusCode == 403) {
        // Rate Limitチェック
        if (response.headers['x-ratelimit-remaining'] == '0') {
          throw GitHubApiError(type: GitHubApiErrorType.rateLimit);
        } else {
          throw GitHubApiError(type: GitHubApiErrorType.serverError);
        }
      } else if (response.statusCode >= 500) {
        throw GitHubApiError(type: GitHubApiErrorType.serverError);
      } else {
        throw GitHubApiError(type: GitHubApiErrorType.unknown, message: 'Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw GitHubApiError(type: GitHubApiErrorType.noInternet);
    } on TimeoutException {
      throw GitHubApiError(type: GitHubApiErrorType.timeout);
    } catch (e) {
      throw GitHubApiError(type: GitHubApiErrorType.unknown, message: e.toString());
    }
  }

  /// カスタム例外からユーザー向けエラーメッセージに変換
  String convertErrorToMessage(dynamic error, AppLocalizations loc) {
    if (error is GitHubApiError) {
      switch (error.type) {
        case GitHubApiErrorType.noInternet:
          return loc.errorNoInternet;
        case GitHubApiErrorType.notFound:
          return loc.errorNotFound;
        case GitHubApiErrorType.serverError:
          return loc.errorServerError;
        case GitHubApiErrorType.rateLimit:
          return loc.errorRateLimit;
        case GitHubApiErrorType.timeout:
          return loc.errorTimeout;
        case GitHubApiErrorType.unknown:
          return loc.errorUnknown;
      }
    }
    // 万が一、型が違うエラーが来た場合もフォールバック
    return loc.errorUnknown;
  }
}
