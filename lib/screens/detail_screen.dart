// screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../utils/license_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/github_api_service.dart'; // README取得用に追加

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
            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.inAppWebView, // アプリ内ブラウザで開く
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ライセンスの詳細ページを開くことができませんでした。')),
              );
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
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.inAppWebView, // アプリ内ブラウザで開く
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('URL を開くことができませんでした。')),
                    );
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
                    return Text(snapshot.data!);
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
