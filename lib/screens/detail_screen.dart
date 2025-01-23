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
                'オーナー: ${repository.ownerName}', // 追加
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
