// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/repository_provider.dart';
import '../widgets/repository_list_item.dart';
import '../utils/constants.dart'; // 言語リストをインポート
import '../utils/license_utils.dart'; // ライセンスマッピングをインポート
import 'detail_screen.dart';

/// リポジトリを検索する画面
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 検索キーワード、オーナー名の入力コントローラ
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();

  // プルダウンで選択された言語とライセンス
  String? _selectedLanguage = programmingLanguages.first;
  String? _selectedLicense = 'Any'; // ライセンス選択の初期値を 'Any' に設定

  // プルダウンで選択されたソート基準とソート順
  String? _selectedSort = 'ベストマッチ'; // ソート基準の初期値（日本語）
  String? _selectedOrder = '降順'; // ソート順の初期値（日本語）

  // ライセンスリストを取得
  final List<String> _licenseOptions = ['Any'] + LicenseUtils.licenseMap.values.map((license) => license['abbreviation'] as String).toList();

  // ソートオプションとソート順のリスト（日本語）
  final List<String> _sortOptions = sortOptions.keys.toList(); // 'ベストマッチ', 'スター数', 'フォーク数', 'ヘルプが必要なイシュー数', '更新日時'
  final List<String> _sortOrderOptions = sortOrderOptions.keys.toList(); // '降順', '昇順'

  /// 検索を実行するメソッド
  void _search() {
    FocusScope.of(context).unfocus(); // キーボードを閉じる

    final query = _queryController.text;
    final owner = _ownerController.text;

    // 'Any'が選択されている場合はライセンスフィルタを適用しない
    final license = (_selectedLicense != null && _selectedLicense != 'Any')
        ? LicenseUtils.licenseMap.entries.firstWhere(
          (entry) => entry.value['abbreviation'] == _selectedLicense,
      orElse: () => MapEntry('unknown', {
        'icon': Icons.help_outline,
        'color': Colors.grey,
        'url': 'https://choosealicense.com/licenses/',
        'abbreviation': 'Unknown',
        'githubKey': '',
      }),
    ).value['githubKey'] as String?
        : null;

    // ソート基準の変換（日本語ラベルからAPIキーへ）
    String? sort;
    if (_selectedSort != null && _selectedSort != 'ベストマッチ') {
      sort = sortOptions[_selectedSort!];
    } else {
      sort = null; // 'ベストマッチ' の場合はソート基準を指定しない
    }

    // ソート順の変換（日本語ラベルからAPIキーへ）
    String? order;
    if (sort != null && _selectedOrder != null) {
      order = sortOrderOptions[_selectedOrder!];
    } else {
      order = null;
    }

    // 'Any'が選択されている場合は言語フィルタを適用しない
    final language = (_selectedLanguage != null && _selectedLanguage != 'Any')
        ? _selectedLanguage
        : null;

    if (query.isNotEmpty) {
      // Providerを通じてリポジトリ検索を実行
      Provider.of<RepositoryProvider>(context, listen: false)
          .search(
        query,
        owner: owner,
        language: language,
        license: license,
        sort: sort,
        order: order,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepositoryProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Search')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 基本検索項目
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: '検索キーワード',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 8),

            // 折りたたみ可能な高度な検索項目
            ExpansionTile(
              title: const Text('高度な検索オプション'),
              initiallyExpanded: false,
              children: [
                const SizedBox(height: 8),
                // オーナー名入力フィールド
                TextField(
                  controller: _ownerController,
                  decoration: const InputDecoration(
                    labelText: 'オーナー名（任意）',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _search(),
                ),
                const SizedBox(height: 8),

                // 言語選択用プルダウン
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration: const InputDecoration(
                    labelText: '言語（任意）',
                    border: OutlineInputBorder(),
                  ),
                  items: programmingLanguages.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  },
                ),
                const SizedBox(height: 8),

                // ライセンス選択用プルダウン
                DropdownButtonFormField<String>(
                  value: _selectedLicense,
                  decoration: const InputDecoration(
                    labelText: 'ライセンス（任意）',
                    border: OutlineInputBorder(),
                  ),
                  items: _licenseOptions.map((license) {
                    return DropdownMenuItem<String>(
                      value: license,
                      child: Text(license),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedLicense = newValue;
                    });
                  },
                ),
                const SizedBox(height: 8),

                // ソート基準選択用プルダウン（日本語）
                DropdownButtonFormField<String>(
                  value: _selectedSort,
                  decoration: const InputDecoration(
                    labelText: 'ソート基準（任意）',
                    border: OutlineInputBorder(),
                  ),
                  items: _sortOptions.map((sort) {
                    return DropdownMenuItem<String>(
                      value: sort,
                      child: Text(sort),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSort = newValue;
                      // ソート順の初期値をリセット（例: '降順'）
                      _selectedOrder = '降順';
                    });
                  },
                ),
                const SizedBox(height: 8),

                // ソート順選択用プルダウン（日本語）
                DropdownButtonFormField<String>(
                  value: _selectedOrder,
                  decoration: const InputDecoration(
                    labelText: 'ソート順（任意）',
                    border: OutlineInputBorder(),
                  ),
                  items: _sortOrderOptions.map((order) {
                    return DropdownMenuItem<String>(
                      value: order,
                      child: Text(order),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOrder = newValue;
                    });
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),

            const SizedBox(height: 8),

            // 検索ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _search,
                child: const Text('検索'),
              ),
            ),
            const SizedBox(height: 16),

            // 検索中のプログレスインジケータ
            if (provider.isLoading)
              const CircularProgressIndicator(),

            // エラーメッセージの表示
            if (provider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // 検索結果リスト
            if (!provider.isLoading && provider.repositories.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: provider.repositories.length,
                  itemBuilder: (context, index) {
                    return RepositoryListItem(
                      repository: provider.repositories[index],
                      onTap: () {
                        // アイテムタップで詳細画面へ遷移
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              repository: provider.repositories[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
