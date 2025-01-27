// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/repository.dart';
import '../utils/license_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/github_api_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailScreen extends StatelessWidget {
  final Repository repository;

  const DetailScreen({super.key, required this.repository}); // 修正: super パラメータ

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
      iconColor = Theme.of(context).colorScheme.onSurface;
      url = 'https://choosealicense.com/licenses/';
      abbreviation = 'Unknown';
    }

    return GestureDetector(
      onTap: () async {
        // 必要な情報を事前に取得
        final loc = AppLocalizations.of(context)!;
        final messenger = ScaffoldMessenger.of(context);
        final snackBarThemeColor = Theme.of(context).snackBarTheme.backgroundColor;

        final uri = Uri.parse(url);
        bool launched = false;
        try {
          launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
          if (!context.mounted) return;

          if (!launched) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(loc.snackbarOpenExternal),
                backgroundColor: snackBarThemeColor,
              ),
            );
            launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (!context.mounted) return;
            if (!launched) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(loc.snackbarLicenseFail),
                  backgroundColor: snackBarThemeColor,
                ),
              );
            }
          }
        } catch (e) {
          if (!context.mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: Text(loc.snackbarErrorAndOpenExternal),
              backgroundColor: snackBarThemeColor,
            ),
          );
          try {
            launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (!context.mounted) return;
            if (!launched) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(loc.snackbarLicenseFail),
                  backgroundColor: snackBarThemeColor,
                ),
              );
            } else {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(loc.snackbarOpenedExternal),
                  backgroundColor: snackBarThemeColor,
                ),
              );
            }
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(loc.snackbarLicenseFail),
                backgroundColor: snackBarThemeColor,
              ),
            );
          }
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: iconColor, size: 20),
          const SizedBox(width: 4),
          Text(
            abbreviation,
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
    final loc = AppLocalizations.of(context)!;
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
                    Navigator.of(context).pop();
                  },
                  child: Text(loc.close),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    final loc = AppLocalizations.of(context)!;
    final String readmeBaseUrl =
        'https://raw.githubusercontent.com/${repository.ownerName}/${repository.name}/HEAD/';

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(repository.ownerAvatarUrl),
                  radius: 40,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SelectableText(
                  loc.ownerLabel(repository.ownerName),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16.0,
                  runSpacing: 8.0,
                  children: [
                    // Stars
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.star,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.stargazersCount}',
                      description: loc.starsDescription,
                    ),
                    // Watchers
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.remove_red_eye,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.watchersCount}',
                      description: loc.watchersDescription,
                    ),
                    // Forks
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.call_split,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.forksCount}',
                      description: loc.forksDescription,
                    ),
                    // Issues
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.error_outline,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      text: '${repository.openIssuesCount}',
                      description: loc.issuesDescription,
                    ),
                    // 言語
                    _buildAttributeItem(
                      context: context,
                      icon: Icons.code,
                      iconColor: Theme.of(context).colorScheme.onSurface,
                      text: repository.language, // 修正: ?? loc.notAvailable を削除
                      description: loc.languageDescription,
                    ),
                    // ライセンス
                    _buildLicenseInfo(context, repository.licenseName),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // 必要な情報を事前に取得
                    final loc = AppLocalizations.of(context)!;
                    final messenger = ScaffoldMessenger.of(context);
                    final snackBarThemeColor = Theme.of(context).snackBarTheme.backgroundColor;

                    final uri = Uri.parse(repository.htmlUrl);
                    bool launched = false;
                    try {
                      launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
                      if (!context.mounted) return;
                      if (!launched) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(loc.snackbarOpenExternal),
                            backgroundColor: snackBarThemeColor,
                          ),
                        );
                        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                        if (!context.mounted) return;
                        if (!launched) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(loc.snackbarUrlFail),
                              backgroundColor: snackBarThemeColor,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(loc.snackbarErrorAndOpenExternal),
                          backgroundColor: snackBarThemeColor,
                        ),
                      );
                      try {
                        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                        if (!context.mounted) return;
                        if (!launched) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(loc.snackbarUrlFail),
                              backgroundColor: snackBarThemeColor,
                            ),
                          );
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(loc.snackbarOpenedExternal),
                              backgroundColor: snackBarThemeColor,
                            ),
                          );
                        }
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(loc.snackbarUrlFail),
                            backgroundColor: snackBarThemeColor,
                          ),
                        );
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/github-mark.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode( // 修正: color → colorFilter
                          Theme.of(context).iconTheme.color ?? Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(loc.openInGitHub),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
                      loc.readmeFetchError(snapshot.error.toString()),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      loc.noReadme,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    );
                  } else {
                    String readmeContent = snapshot.data!;

                    // RSTをMarkdownに変換する前処理を追加
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

                    final RegExp heading1RegExp = RegExp(
                      r'^(.*?)\n=+\n',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(heading1RegExp, (match) {
                      final title = match.group(1)?.trim() ?? '';
                      return '# $title\n\n';
                    });

                    final RegExp heading2RegExp = RegExp(
                      r'^(.*?)\n-+\n',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(heading2RegExp, (match) {
                      final title = match.group(1)?.trim() ?? '';
                      return '## $title\n\n';
                    });

                    final RegExp heading3RegExp = RegExp(
                      r'^(.*?)\n~+\n',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(heading3RegExp, (match) {
                      final title = match.group(1)?.trim() ?? '';
                      return '### $title\n\n';
                    });

                    final RegExp linkRegExp = RegExp(
                      r'`([^`<]+)\s*<([^>]+)>`_',
                      multiLine: true,
                    );
                    readmeContent = readmeContent.replaceAllMapped(linkRegExp, (match) {
                      final text = match.group(1)?.trim() ?? '';
                      final url = match.group(2)?.trim() ?? '';
                      return '[$text]($url)';
                    });

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

                    return MarkdownBody(
                      selectable: true,
                      data: readmeContent,
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          // 必要な情報を事前に取得
                          final loc = AppLocalizations.of(context)!;
                          final messenger = ScaffoldMessenger.of(context);
                          final snackBarThemeColor = Theme.of(context).snackBarTheme.backgroundColor;

                          final uri = Uri.parse(href);
                          bool launched = false;
                          try {
                            launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
                            if (!context.mounted) return;

                            if (!launched) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(loc.snackbarOpenExternal),
                                  backgroundColor: snackBarThemeColor,
                                ),
                              );
                              launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                              if (!context.mounted) return;
                              if (!launched) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(loc.snackbarLinkFail),
                                    backgroundColor: snackBarThemeColor,
                                  ),
                                );
                              }
                            } else {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(loc.snackbarOpenedExternal),
                                  backgroundColor: snackBarThemeColor,
                                ),
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(loc.snackbarLinkError),
                                backgroundColor: snackBarThemeColor,
                              ),
                            );
                          }
                        }
                      },
                      imageBuilder: (uri, title, alt) {
                        final String imageUrl = uri.isAbsolute
                            ? uri.toString()
                            : Uri.parse(readmeBaseUrl).resolve(uri.toString()).toString();

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
                            height: 24,
                            width: 24,
                            fit: BoxFit.contain,
                          );
                        } else {
                          return Image.network(
                            imageUrl,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                loc.imageLoadFail(alt ?? loc.unknownImage),
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
