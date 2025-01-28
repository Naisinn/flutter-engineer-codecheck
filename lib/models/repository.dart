// models/repository.dart

/// GitHubリポジトリのデータモデル
class Repository {
  final String name;
  final String ownerAvatarUrl;
  final String ownerName;
  final String language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String htmlUrl;
  final String licenseName;
  final DateTime updatedAt; // 追加: 更新日時

  Repository({
    required this.name,
    required this.ownerAvatarUrl,
    required this.ownerName,
    required this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    required this.htmlUrl,
    required this.licenseName,
    required this.updatedAt, // 追加
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? '',
      ownerAvatarUrl: json['owner']['avatar_url'] ?? '',
      ownerName: json['owner']['login'] ?? '',
      language: json['language'] ?? 'N/A',
      stargazersCount: json['stargazers_count'] ?? 0,
      watchersCount: json['watchers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      openIssuesCount: json['open_issues_count'] ?? 0,
      htmlUrl: json['html_url'] ?? '',
      licenseName: json['license'] != null ? json['license']['name'] : 'ライセンス情報なし',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(), // 追加: 更新日時のパース
    );
  }
}
