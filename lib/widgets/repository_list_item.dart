import 'package:flutter/material.dart';
import '../models/repository.dart';

class RepositoryListItem extends StatelessWidget {
  final Repository repository;
  final VoidCallback onTap;

  const RepositoryListItem({Key? key, required this.repository, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(repository.name),
      onTap: onTap,
    );
  }
}
