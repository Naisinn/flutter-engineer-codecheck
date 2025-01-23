// widgets/repository_list_item.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';

/// リポジトリ一覧の各アイテムを表すウィジェット
class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryListItem({Key? key, required this.repository, required this.onTap}) : super(key: key);

  // ライセンス名に応じたアイコンと色を取得するヘルパーメソッド
  Widget _buildLicenseInfo(String licenseName) {
    IconData iconData;
    Color iconColor;

    switch (licenseName.toLowerCase()) {
      case 'mit license':
        iconData = Icons.verified;
        iconColor = Colors.green;
        break;
      case 'apache license 2.0':
        iconData = Icons.business;
        iconColor = Colors.blue;
        break;
      case 'gnu general public license v3.0':
        iconData = Icons.gavel;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.help_outline;
        iconColor = Colors.grey;
    }

    return Row(
      children: [
        Icon(iconData, color: iconColor, size: 16),
        const SizedBox(width: 4),
        Text('ライセンス: $licenseName'),
      ],
    );
  }

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
          _buildLicenseInfo(repository.licenseName), // ライセンス情報にアイコンと色を追加
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
