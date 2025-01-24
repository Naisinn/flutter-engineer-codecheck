// screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../utils/license_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/github_api_service.dart'; // README取得用に追加
import 'package:flutter_markdown/flutter_markdown.dart'; // 追加: flutter_markdown パッケージのインポート
import 'package:flutter_svg/flutter_svg.dart'; // 追加: flutter_svg パッケージのインポート

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
      iconColor = Theme.of(context).colorScheme.onSurface; // ダークモード対応
      url = 'https://choosealicense.com/licenses/';
      abbreviation = 'Unknown';
    }

    return GestureDetector(
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
              SnackBar(
                content: Text('内部ブラウザで開けなかったため、外部ブラウザで開きます。'),
                backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
              ),
            );
            launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
            if (!launched) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ライセンスの詳細ページを開くことができませんでした。'),
                  backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                ),
              );
            }
          }
        } catch (e) {
          // 例外が発生した場合も外部ブラウザを試みる前にSnackBarを表示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('エラーが発生しました。外部ブラウザで開きます。'),
              backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            ),
          );
          try {
            launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
            if (!launched) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ライセンスの詳細ページを開くことができませんでした。'),
                  backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('外部ブラウザで開きました。'),
                  backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ライセンスの詳細ページを開くことができませんでした。'),
                backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
              ),
            );
          }
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min, // Rowが必要最小限の幅を取るように設定
        children: [
          Icon(iconData, color: iconColor, size: 20),
          const SizedBox(width: 4),
          Text(
            abbreviation, // 略称を表示
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 新規追加: ヘルパーメソッドで属性情報のウィジェットを生成
  Widget _buildAttributeItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String text,
    required String description,
  }) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(description),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ダイアログを閉じる
                  },
                  child: Text('閉じる'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min, // Rowが必要最小限の幅を取るように設定
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // README のベース URLを設定（画像の相対パスを絶対パスに変換するため）
    final String readmeBaseUrl = 'https://raw.githubusercontent.com/${repository.ownerName}/${repository.name}/HEAD/';

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                child: SelectableText(
                  'オーナー: ${repository.ownerName}', // 追加
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center( // 追加: WrapをCenterでラップ
                child: Wrap(
                  alignment: WrapAlignment.center, // 中央揃えに設定
                  spacing: 16.0, // アイテム間の水平スペース
                  runSpacing: 8.0, // 行間の垂直スペース
                  children: [
                    // Stars
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.star,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.stargazersCount}',
                      description:
                      'Stars: このリポジトリにスターを付けたユーザーの数です。',
                    ),
                    // Watchers
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.remove_red_eye,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.watchersCount}',
                      description:
                      'Watchers: このリポジトリをウォッチしているユーザーの数です。',
                    ),
                    // Forks
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.call_split,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.forksCount}',
                      description:
                      'Forks: このリポジトリがフォークされた回数です。',
                    ),
                    // Issues
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.error_outline,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.openIssuesCount}',
                      description:
                      'Issues: このリポジトリの現在開いている課題の数です。',
                    ),
                    // 言語
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.code,
                      iconColor: Theme.of(context).colorScheme.onSurface,
                      text: repository.language ?? 'N/A',
                      description:
                      '言語: このリポジトリで主に使用されているプログラミング言語です。',
                    ),
                    // ライセンス
                    _buildLicenseInfo(context, repository.licenseName),
                  ],
                ),
              ),

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
                        SnackBar(
                          content: Text('内部ブラウザで開けなかったため、外部ブラウザで開きます。'),
                          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                        ),
                      );
                      launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('URL を開くことができませんでした。'),
                            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // 例外が発生した場合も外部ブラウザを試みる前にSnackBarを表示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('エラーが発生しました。外部ブラウザで開きます。'),
                        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                      ),
                    );
                    try {
                      launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('URL を開くことができませんでした。'),
                            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('外部ブラウザで開きました。'),
                            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('URL を開くことができませんでした。'),
                          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                        ),
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
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'READMEがありません。',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    );
                  } else {
                    String readmeContent = snapshot.data!;

                    // RSTをMarkdownに変換する前処理を追加
                    // 1. 画像ディレクティブの変換
                    final RegExp imageRegExp = RegExp(
                      r'\.\.\s+image::\s+(\S+)\s+:alt:\s+([^:]+)\s+:target:\s+(\S+)',
                      multiLine: true,
                    );

                    readmeContent = readmeContent.replaceAllMapped(imageRegExp, (match) {
                      final imageUrl = match.group(1)?.trim() ?? '';
                      final altText = match.group(2)?.trim() ?? '';
                      final targetUrl = match.group(3)?.trim() ?? '';
                      return '[![$altText]($imageUrl)]($targetUrl)';
                    });

                    // 2. 見出しの変換
                    // RSTの見出しは、テキストの下に等号やハイフンなどで装飾されます。
                    // これをMarkdownの#、##に変換します。
                    // ここでは、'=' がレベル1、'-' がレベル2、'^' がレベル3として処理します。

                    // レベル1 見出し
                    final RegExp heading1RegExp = RegExp(
                      r'^(.*?)\n=+\n',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(heading1RegExp, (match) {
                      final title = match.group(1)?.trim() ?? '';
                      return '# $title\n\n';
                    });

                    // レベル2 見出し
                    final RegExp heading2RegExp = RegExp(
                      r'^(.*?)\n-+\n',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(heading2RegExp, (match) {
                      final title = match.group(1)?.trim() ?? '';
                      return '## $title\n\n';
                    });

                    // レベル3 見出し
                    final RegExp heading3RegExp = RegExp(
                      r'^(.*?)\n~+\n',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(heading3RegExp, (match) {
                      final title = match.group(1)?.trim() ?? '';
                      return '### $title\n\n';
                    });

                    // 3. 太字と斜体の変換
                    // RSTでは、*斜体*、**太字** などが使用されますが、Markdownと同様の形式なので特別な変換は不要です。

                    // 4. リストの変換
                    // RSTの箇条書きリストは、'- ' や '* ' で始まります。Markdownと同様なので特別な変換は不要です。

                    // 5. リンクの変換
                    // RSTのリンクは、`link text <URL>`_ の形式です。これをMarkdownの[link text](URL)に変換します。
                    final RegExp linkRegExp = RegExp(
                      r'`([^`<]+)\s*<([^>]+)>`_',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(linkRegExp, (match) {
                      final text = match.group(1)?.trim() ?? '';
                      final url = match.group(2)?.trim() ?? '';
                      return '[$text]($url)';
                    });

                    // 6. コードブロックの変換
                    // RSTのコードブロックは、:: の後にインデントされたテキストで表現されます。
                    // これをMarkdownの```で囲まれたブロックに変換します。
                    final RegExp codeBlockRegExp = RegExp(
                      r'::\n((?:\n| +.+)+)',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(codeBlockRegExp, (match) {
                      final code = match.group(1)
                          ?.replaceAll(RegExp(r'^\s{4}', multiLine: true), '') ??
                          '';
                      return '```\n$code\n```\n';
                    });

                    // 7. 引用の変換
                    // RSTの引用は、"> " で始まる行で表現されます。Markdownと同様の形式なので特別な変換は不要です。

                    // 8. その他の変換
                    // 必要に応じて追加の変換ロジックをここに追加します。

                    return MarkdownBody(
                      selectable: true, // 追加: Markdownを選択可能にする
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
                                SnackBar(
                                  content: Text('内部ブラウザで開けなかったため、外部ブラウザで開きます。'),
                                  backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                                ),
                              );
                              launched = await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              if (!launched) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('リンクを開くことができませんでした。'),
                                    backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('リンクを開きました。'),
                                  backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('エラーが発生しました。リンクを開けません。'),
                                backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                              ),
                            );
                          }
                        }
                      },
                      imageBuilder: (uri, title, alt) {
                        final String imageUrl = uri.isAbsolute
                            ? uri.toString()
                            : Uri.parse(readmeBaseUrl).resolve(uri.toString()).toString();

                        // URLのパス部分を解析して拡張子をチェック
                        final Uri parsedUri = Uri.parse(imageUrl);
                        if (parsedUri.path.toLowerCase().endsWith('.svg')) {
                          return SvgPicture.network(
                            imageUrl,
                            placeholderBuilder: (context) => SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            // エラーハンドリングを追加するために、カスタムウィジェットを使用
                            // flutter_svg では直接的なエラーハンドリングはサポートされていないため、
                            // 以下の方法で簡易的なエラーハンドリングを実装します
                            height: 24, // 必要に応じてサイズを調整
                            width: 24,
                            fit: BoxFit.contain,
                          );
                        } else {
                          return Image.network(
                            imageUrl,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                '画像を読み込めませんでした: ${alt ?? 'Unknown Image'}',
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              );
                            },
                          );
                        }
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
