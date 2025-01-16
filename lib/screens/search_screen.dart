import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/repository_provider.dart';
import '../widgets/repository_list_item.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  void _search() {
    final query = _controller.text;
    if (query.isNotEmpty) {
      Provider.of<RepositoryProvider>(context, listen: false).search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepositoryProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: '検索キーワード',
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ],
            ),
          ),
          if (provider.isLoading)
            const CircularProgressIndicator(),
          if (provider.errorMessage != null)
            Text(provider.errorMessage!),
          Expanded(
            child: ListView.builder(
              itemCount: provider.repositories.length,
              itemBuilder: (context, index) {
                return RepositoryListItem(
                  repository: provider.repositories[index],
                  onTap: () {
                    // 詳細画面へ遷移する処理
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(repository: provider.repositories[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
