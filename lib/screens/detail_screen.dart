// screens/detail_screen.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final Repository repository;

  const DetailScreen({Key? key, required this.repository}) : super(key: key);

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
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(repository.ownerAvatarUrl),
                radius: 40,
              ),
              const SizedBox(height: 8), // サイズ調整
              Text(
                'オーナー: ${repository.ownerName}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              // ライセンス名をタップすると詳細ページに遷移
              GestureDetector(
                onTap: () {
                  // ライセンス名に基づいて詳細ページのURLを生成
                  String licenseUrl;
                  switch (repository.licenseName.toLowerCase()) {
                    case 'mit license':
                      licenseUrl = 'https://opensource.org/licenses/MIT';
                      break;
                    case 'apache license 2.0':
                      licenseUrl = 'https://www.apache.org/licenses/LICENSE-2.0';
                      break;
                    case 'gnu general public license v3.0':
                      licenseUrl = 'https://www.gnu.org/licenses/gpl-3.0.en.html';
                      break;
                    default:
                      licenseUrl = 'https://choosealicense.com/licenses/';
                  }

                  launchUrl(Uri.parse(licenseUrl));
                },
                child: Text(
                  'ライセンス: ${repository.licenseName}',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(repository.htmlUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('URL を開くことができませんでした。')),
                    );
                  }
                },
                child: const Text('GitHubで開く'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
