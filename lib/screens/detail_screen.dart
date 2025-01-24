// screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../utils/license_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/github_api_service.dart'; // README取得用に追加
import 'package:flutter_markdown/flutter_markdown.dart'; // 追加: flutter_markdown パッケージのインポート

class DetailScreen extends StatelessWidget {
  final Repository repository;

  const DetailScreen({Key? key, required this.repository}) : super(key: key);

  // 共通のライセンスマッピングを使用するヘルパーメソッド
  Widget _buildLicenseInfo(BuildContext context, String licenseName) {
    final licenseKey = licenseName.toLowerCase();
    final licenseData = LicenseUtils.licenseMap[licenseKey];

    IconData iconData;
    Color iconColor;
    String url;
    String abbreviation;

    if (licenseData != null) {
      iconData = licenseData['icon'];
      iconColor = licenseData['color'];
      url = licenseData['url'];
      abbreviation = licenseData['abbreviation'];
    } else {
      iconData = Icons.help_outline;
      iconColor = Colors.grey;
      url = 'https://choosealicense.com/licenses/';
      abbreviation = 'Unknown';
    }

    return Row(
      children: [
        Icon(iconData, color: iconColor),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse(url);
            bool launched = false;
            try {
              // 内部ブラウザで開くことを試みる
              launched = await launchUrl(
                uri,
                mode: LaunchMode.inAppWebView,
              );
              if (!launched) {
                // 内部ブラウザで開けなかった場合、SnackBarを表示してから外部ブラウザを開く
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('内部ブラウザで開けなかったため、外部ブラウザで開きます。')),
                );
                launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (!launched) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ライセンスの詳細ページを開くことができませんでした。')),
                  );
                }
              }
            } catch (e) {
              // 例外が発生した場合も外部ブラウザを試みる前にSnackBarを表示
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('エラーが発生しました。外部ブラウザで開きます。')),
              );
              try {
                launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (!launched) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ライセンスの詳細ページを開くことができませんでした。')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('外部ブラウザで開きました。')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ライセンスの詳細ページを開くことができませんでした。')),
                );
              }
            }
          },
          child: Text(
            'ライセンス: $abbreviation', // 略称を表示
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // README のベース URLを設定（画像の相対パスを絶対パスに変換するため）
    final String readmeBaseUrl = 'https://raw.githubusercontent.com/${repository.ownerName}/${repository.name}/HEAD/';

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 左揃えに変更
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(repository.ownerAvatarUrl),
                  radius: 40,
                ),
              ),
              const SizedBox(height: 8), // サイズ調整
              Center(
                child: Text(
                  'オーナー: ${repository.ownerName}', // 追加
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text('言語: ${repository.language}'),
              const SizedBox(height: 8),
              Text('Stars: ${repository.stargazersCount}'),
              const SizedBox(height: 8),
              Text('Watchers: ${repository.watchersCount}'),
              const SizedBox(height: 8),
              Text('Forks: ${repository.forksCount}'),
              const SizedBox(height: 8),
              Text('Issues: ${repository.openIssuesCount}'),
              const SizedBox(height: 8),
              _buildLicenseInfo(context, repository.licenseName), // ライセンス情報をアイコン付きで表示
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(repository.htmlUrl);
                  bool launched = false;
                  try {
                    // 内部ブラウザで開くことを試みる
                    launched = await launchUrl(
                      uri,
                      mode: LaunchMode.inAppWebView,
                    );
                    if (!launched) {
                      // 内部ブラウザで開けなかった場合、SnackBarを表示してから外部ブラウザを開く
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('内部ブラウザで開けなかったため、外部ブラウザで開きます。')),
                      );
                      launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('URL を開くことができませんでした。')),
                        );
                      }
                    }
                  } catch (e) {
                    // 例外が発生した場合も外部ブラウザを試みる前にSnackBarを表示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('エラーが発生しました。外部ブラウザで開きます。')),
                    );
                    try {
                      launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('URL を開くことができませんでした。')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('外部ブラウザで開きました。')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('URL を開くことができませんでした。')),
                      );
                    }
                  }
                },
                child: const Text('GitHubで開く'),
              ),
              const SizedBox(height: 24), // README表示との間隔調整

              FutureBuilder<String>(
                future: GitHubApiService().fetchReadme(
                  repository.ownerName,
                  repository.name,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                      'READMEを取得できませんでした: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('READMEがありません。');
                  } else {
                    final String readmeContent = snapshot.data!;

                    return MarkdownBody( // 変更: Text を MarkdownBody に変更
                      data: readmeContent,
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          final uri = Uri.parse(href);
                          bool launched = false;
                          try {
                            launched = await launchUrl(
                              uri,
                              mode: LaunchMode.inAppWebView,
                            );
                            if (!launched) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('内部ブラウザで開けなかったため、外部ブラウザで開きます。')),
                              );
                              launched = await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              if (!launched) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('リンクを開くことができませんでした。')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('リンクを開きました。')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラーが発生しました。リンクを開けません。')),
                            );
                          }
                        }
                      },
                      imageBuilder: (uri, title, alt) { // 追加: 画像のビルダーをカスタマイズ
                        // 画像のURLが相対パスの場合、リポジトリのベースURLを使用して絶対URLを生成
                        final String imageUrl = uri.isAbsolute
                            ? uri.toString()
                            : Uri.parse(readmeBaseUrl).resolve(uri.toString()).toString();
                        return Image.network(
                          imageUrl,
                          errorBuilder: (context, error, stackTrace) {
                            return Text('画像を読み込めませんでした: ${alt ?? 'Unknown Image'}');
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
