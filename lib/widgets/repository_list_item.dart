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
      title: Text(repository.name),
      onTap: onTap,  // タップ時に指定されたコールバックを実行
    );
  }
}
