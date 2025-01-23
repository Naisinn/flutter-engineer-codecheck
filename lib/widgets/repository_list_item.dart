// widgets/repository_list_item.dart

import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../utils/license_utils.dart'; // 追加

/// リポジトリ一覧の各アイテムを表すウィジェット
class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryListItem({Key? key, required this.repository, required this.onTap}) : super(key: key);

  // 共通のライセンスマッピングを使用するヘルパーメソッド
  Widget _buildLicenseInfo(String licenseName) {
    final licenseKey = licenseName.toLowerCase();
    final licenseData = LicenseUtils.licenseMap[licenseKey];

    IconData iconData;
    Color iconColor;
    String abbreviation;

    if (licenseData != null) {
      iconData = licenseData['icon'];
      iconColor = licenseData['color'];
      abbreviation = licenseData['abbreviation'];
    } else {
      iconData = Icons.help_outline;
      iconColor = Colors.grey;
      abbreviation = 'Unknown';
    }

    return Row(
      children: [
        Icon(iconData, color: iconColor, size: 16),
        const SizedBox(width: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            abbreviation,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ),
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
          _buildLicenseInfo(repository.licenseName), // ライセンス情報にアイコンと略称を追加
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
      onTap: onTap, // タップ時に指定されたコールバックを実行
    );
  }
}
