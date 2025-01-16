// models/repository.dart

/// GitHubリポジトリのデータモデル
class Repository {
  final String name;
  final String ownerAvatarUrl;
  final String language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;

  Repository({
    required this.name,
    required this.ownerAvatarUrl,
    required this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
  });

  /// JSONデータからRepositoryインスタンスを生成するファクトリメソッド
  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? '',
      ownerAvatarUrl: json['owner']['avatar_url'] ?? '',
      language: json['language'] ?? 'N/A',
      stargazersCount: json['stargazers_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      openIssuesCount: json['open_issues_count'] ?? 0,
    );
  }
}
