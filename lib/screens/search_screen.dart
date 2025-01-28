// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/repository_provider.dart';
import '../widgets/repository_list_item.dart';
import '../utils/constants.dart'; // 言語リストをインポート
import '../utils/license_utils.dart'; // ライセンスマッピングをインポート
import 'detail_screen.dart';

/// リポジトリを検索する画面
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  // 検索キーワード、オーナー名の入力コントローラ
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();

  // 言語選択ドロップダウンの初期値とライセンスドロップダウンの初期値
  String? _selectedLanguage = programmingLanguages.first;
  String? _selectedLicense = 'Any';

  // 以下の2つはソート基準とソート順の**実際にAPIに渡すパラメータ**を保持します。
  // ソート基準の初期値は '': "ベストマッチ" に対応
  String _selectedSortValue = '';
  // ソート順の初期値は 'desc'
  String _selectedOrderValue = 'desc';

  // ライセンスリストを取得（"Any" + ライセンス略称）
  final List<String> _licenseOptions = [
    'Any',
    ...LicenseUtils.licenseMap.values
        .map((license) => license['abbreviation'] as String)
  ];

  /// 検索を実行するメソッド
  Future<void> _search() async {
    FocusScope.of(context).unfocus(); // キーボードを閉じる

    final query = _queryController.text;
    final owner = _ownerController.text;

    // 'Any'が選択されている場合はライセンスフィルタを適用しない
    final license = (_selectedLicense != null && _selectedLicense != 'Any')
        ? LicenseUtils.licenseMap.entries
        .firstWhere(
          (entry) => entry.value['abbreviation'] == _selectedLicense,
      orElse: () => MapEntry(
        'unknown',
        {
          'icon': Icons.help_outline,
          'color': Colors.grey,
          'url': 'https://choosealicense.com/licenses/',
          'abbreviation': 'Unknown',
          'githubKey': '',
        },
      ),
    )
        .value['githubKey'] as String?
        : null;

    // ソート基準: '' は「ベストマッチ」に対応するため、検索時は null を渡す
    final sort = _selectedSortValue.isEmpty ? null : _selectedSortValue;

    // ソート順: 'desc' or 'asc'
    final order = _selectedOrderValue.isEmpty ? null : _selectedOrderValue;

    // 'Any'が選択されている場合は言語フィルタを適用しない
    final language = (_selectedLanguage != null && _selectedLanguage != 'Any')
        ? _selectedLanguage
        : null;

    // Providerからsearchを呼び出し
    await Provider.of<RepositoryProvider>(context, listen: false).search(
      query,
      owner: owner,
      language: language,
      license: license,
      sort: sort,
      order: order,
    );

    if (!mounted) return; // 非同期処理後にcontextを扱うならmountedチェック
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<RepositoryProvider>(context);

    // ソート基準の選択肢をローカライズ
    // value: 実際のAPIパラメータ, label: 画面表示
    final sortOptionsLocalized = [
      {'value': '', 'label': loc.sortCriteriaBestMatch}, // ベストマッチ
      {'value': 'stars', 'label': loc.sortCriteriaStars},
      {'value': 'forks', 'label': loc.sortCriteriaForks},
      {'value': 'help-wanted-issues', 'label': loc.sortCriteriaHelpWantedIssues},
      {'value': 'updated', 'label': loc.sortCriteriaUpdated},
    ];

    // ソート順の選択肢をローカライズ
    final sortOrderLocalized = [
      {'value': 'desc', 'label': loc.sortOrderDesc}, // 降順
      {'value': 'asc', 'label': loc.sortOrderAsc},   // 昇順
    ];

    // 現在のAPIパラメータをもとに、ラベルなどを生成
    return Scaffold(
      appBar: AppBar(title: Text(loc.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // 折りたたみ可能な検索フォーム
          ExpansionTile(
            title: Text(loc.searchForm),
            initiallyExpanded: true,
            children: [
              // 基本検索項目
              TextField(
                controller: _queryController,
                decoration: InputDecoration(
                  labelText: loc.searchKeyword,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _search(),
              ),
              const SizedBox(height: 8),

              // 折りたたみ可能な高度な検索項目
              ExpansionTile(
                title: Text(loc.advancedSearchOptions),
                initiallyExpanded: false,
                children: [
                  const SizedBox(height: 8),
                  // オーナー名入力フィールド
                  TextField(
                    controller: _ownerController,
                    decoration: InputDecoration(
                      labelText: loc.ownerNameOptional,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                  const SizedBox(height: 8),

                  // 言語選択用プルダウン
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: loc.languageOptional,
                      border: const OutlineInputBorder(),
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
                    decoration: InputDecoration(
                      labelText: loc.licenseOptional,
                      border: const OutlineInputBorder(),
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

                  // ソート基準選択用プルダウン（ローカライズされたラベル）
                  DropdownButtonFormField<String>(
                    value: _selectedSortValue,
                    decoration: InputDecoration(
                      labelText: loc.sortCriteriaOptional,
                      border: const OutlineInputBorder(),
                    ),
                    items: sortOptionsLocalized.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['label'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSortValue = newValue ?? '';
                        // ソート基準を変更したら、ソート順は降順('desc')にリセットする等の挙動が必要ならここで対処
                        // 例: _selectedOrderValue = 'desc';
                      });
                    },
                  ),
                  const SizedBox(height: 8),

                  // ソート順選択用プルダウン（ローカライズされたラベル）
                  DropdownButtonFormField<String>(
                    value: _selectedOrderValue,
                    decoration: InputDecoration(
                      labelText: loc.sortOrderOptional,
                      border: const OutlineInputBorder(),
                    ),
                    items: sortOrderLocalized.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['label'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOrderValue = newValue ?? 'desc';
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
                  child: Text(loc.searchButton),
                ),
              ),
              const SizedBox(height: 16),

              // 検索中のプログレスインジケータ
              if (provider.isLoading) const CircularProgressIndicator(),

              // エラーメッセージの表示
              if (provider.errorType != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _getErrorMessage(provider.errorType!, loc),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),

          // 検索結果リスト
          if (!provider.isLoading && provider.repositories.isNotEmpty)
            ...provider.repositories.map(
                  (repo) => RepositoryListItem(
                repository: repo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(repository: repo),
                    ),
                  );
                },
                // リストアイテムにAPIパラメータを渡す
                sortCriteria: _selectedSortValue.isEmpty
                    ? 'stars' // ベストマッチ時はスター数表示をデフォルトに
                    : _selectedSortValue,
              ),
            ),
        ],
      ),
    );
  }

  /// エラーメッセージを取得するヘルパーメソッド
  String _getErrorMessage(RepositoryErrorType errorType, AppLocalizations loc) {
    switch (errorType) {
      case RepositoryErrorType.noInternet:
        return loc.errorNoInternet;
      case RepositoryErrorType.notFound:
        return loc.errorNotFound;
      case RepositoryErrorType.serverError:
        return loc.errorServerError;
      case RepositoryErrorType.rateLimit:
        return loc.errorRateLimit;
      case RepositoryErrorType.timeout:
        return loc.errorTimeout;
      case RepositoryErrorType.noResults:
        return loc.errorNoResults;
      case RepositoryErrorType.unknown:
        return loc.errorUnknown;
    }
    // すべて網羅しているため、default句は不要
  }
}
