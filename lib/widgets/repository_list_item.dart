// widgets/repository_list_item.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';

/// リポジトリ一覧の各アイテムを表すウィジェット
class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryListItem({Key? key, required this.repository, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(repository.ownerAvatarUrl),
      ),
      title: Text(repository.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(repository.language), // 言語をサブタイトルとして表示
          Text('オーナー: ${repository.ownerName}'), // オーナー名を追加
          Text('ライセンス: ${repository.licenseName}'), // ライセンス情報を追加
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // スターアイコンと数を表示
          const Icon(Icons.star, size: 16),
          const SizedBox(width: 4),
          Text(repository.stargazersCount.toString()),
        ],
      ),
      onTap: onTap,  // タップ時に指定されたコールバックを実行
    );
  }
}
