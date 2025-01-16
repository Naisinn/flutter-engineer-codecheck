// screens/detail_screen.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';

/// リポジトリの詳細情報を表示する画面
class DetailScreen extends StatelessWidget {
  final Repository repository;

  const DetailScreen({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // オーナーのアバター画像を表示
            CircleAvatar(
              backgroundImage: NetworkImage(repository.ownerAvatarUrl),
              radius: 40,
            ),
            const SizedBox(height: 16),
            // 言語、Star数、Watcher数、Fork数、Issue数を表示
            Text('言語: ${repository.language}'),
            const SizedBox(height: 8),
            Text('Stars: ${repository.stargazersCount}'),
            const SizedBox(height: 8),
            Text('Watchers: ${repository.watchersCount}'),
            const SizedBox(height: 8),
            Text('Forks: ${repository.forksCount}'),
            const SizedBox(height: 8),
            Text('Issues: ${repository.openIssuesCount}'),
          ],
        ),
      ),
    );
  }
}
