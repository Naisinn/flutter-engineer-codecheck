// utils/constants.dart

// プログラミング言語のリスト
const List<String> programmingLanguages = [
  'Any',
  'Dart',
  'JavaScript',
  'Python',
  'Java',
  'C#',
  'C++',
  'Ruby',
  'Go',
  'TypeScript',
  // 他の言語を追加
];

// ソート基準のマッピング（日本語ラベル : GitHub APIキー）
const Map<String, String> sortOptions = {
  'ベストマッチ': '', // デフォルト（ソート基準なし）
  'スター数': 'stars',
  'フォーク数': 'forks',
  'ヘルプが必要なイシュー数': 'help-wanted-issues',
  '更新日時': 'updated',
};

// ソート順のマッピング（日本語ラベル : GitHub APIキー）
const Map<String, String> sortOrderOptions = {
  '降順': 'desc',
  '昇順': 'asc',
};
