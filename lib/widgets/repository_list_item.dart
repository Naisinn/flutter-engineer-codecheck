// widgets/repository_list_item.dart
import 'package:flutter/material.dart';
import '../models/repository.dart';
import '../utils/license_utils.dart'; // 追加

/// リポジトリ一覧の各アイテムを表すウィジェット
class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;
  final String sortCriteria; // 追加: ソート基準

  const RepositoryListItem({
    Key? key,
    required this.repository,
    required this.onTap,
    required this.sortCriteria, // 追加
  }) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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

  /// ソート基準に応じて表示する値を返すヘルパーメソッド
  String _getSortValue() {
    switch (sortCriteria) {
      case 'stars':
        return repository.stargazersCount.toString();
      case 'forks':
        return repository.forksCount.toString();
      case 'help-wanted-issues':
        return repository.openIssuesCount.toString();
      case 'updated':
        return '${repository.updatedAt.year}-${repository.updatedAt.month.toString().padLeft(2, '0')}-${repository.updatedAt.day.toString().padLeft(2, '0')}';
      default:
        return repository.stargazersCount.toString(); // デフォルトはスター数
    }
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
          // ソート基準に応じたアイコンと数値を表示
          Icon(
            _getTrailingIcon(),
            size: 16,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 4),
          Text(_getSortValue()),
        ],
      ),
      onTap: onTap, // タップ時に指定されたコールバックを実行
    );
  }

  /// ソート基準に応じたアイコンを返すヘルパーメソッド
  IconData _getTrailingIcon() {
    switch (sortCriteria) {
      case 'stars':
        return Icons.star;
      case 'forks':
        return Icons.call_split;
      case 'help-wanted-issues':
        return Icons.error_outline;
      case 'updated':
        return Icons.update;
      default:
        return Icons.star; // デフォルトはスターアイコン
    }
  }
}
