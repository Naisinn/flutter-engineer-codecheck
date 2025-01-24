```markdown
# flutter_engineer_codecheck

## 日本語版

### プロジェクト概要

このプロジェクトは、[株式会社ゆめみ](https://www.yumemi.co.jp/) 様が Flutter エンジニアを希望する方に与えるコードチェック課題（[要件](#株式会社ゆめみ-flutter-エンジニアコードチェック課題)）に基づいて作成したものです。  
GitHub リポジトリを検索し、詳細情報（スター数、ウォッチ数、フォーク数、イシュー数、README など）を確認できる Flutter アプリです。

### デモ・スクリーンショット

*ご利用の際に、必要に応じてスクリーンショットや GIF アニメを貼ってください。  
例: ダークモード・ライトモードそれぞれのキャプチャなど*

### 主な機能
- GitHub リポジトリ検索（キーワードで検索可能）
- 高度な検索オプション（オーナー名、言語、ライセンス、ソート指定など）
- 詳細画面でリポジトリの各種情報表示（オーナーアイコン、リポジトリ名、スター数、ウォッチ数、フォーク数、イシュー数、使用言語、ライセンスなど）
- README を Markdown 表示
- ダークモード対応

### フォルダ構造

```plaintext
.
├── main.dart
├── models
│   └── repository.dart
├── providers
│   └── repository_provider.dart
├── screens
│   ├── detail_screen.dart
│   └── search_screen.dart
├── services
│   └── github_api_service.dart
├── utils
│   ├── constants.dart
│   └── license_utils.dart
└── widgets
    └── repository_list_item.dart
```

- **main.dart**  
  アプリのエントリーポイント。`MaterialApp` の設定や、プロバイダーの初期化などを行います。
- **models/**  
  ドメインモデルを定義します。`Repository` クラスなど。
- **providers/**  
  検索処理や取得データの管理を担う `RepositoryProvider` など、`ChangeNotifier` を利用した状態管理ロジックを配置しています。
- **screens/**  
  画面（UI）の実装。検索画面 (`search_screen.dart`)、詳細画面 (`detail_screen.dart`)。
- **services/**  
  API 呼び出しなど、外部サービスとの通信やビジネスロジックに近い機能を実装します。`github_api_service.dart` など。
- **utils/**  
  定数 (`constants.dart`) やライセンス情報をまとめたヘルパー (`license_utils.dart`) を配置。
- **widgets/**  
  汎用的なウィジェットや分割したコンポーネントを配置。例: 検索結果のリストアイテム (`repository_list_item.dart`)。

### セットアップ・導入手順

1. **リポジトリをクローン**

   ```bash
   git clone https://github.com/your-username/flutter_engineer_codecheck.git
   cd flutter_engineer_codecheck
   ```

2. **依存関係をインストール**

   ```bash
   flutter pub get
   ```

3. **アプリを実行**

   ```bash
   flutter run
   ```

    - Android シミュレータ / 実機、または iOS シミュレータ / 実機で起動可能です。
    - エミュレータや実機が接続された状態でコマンドを実行してください。

### 依存関係

`pubspec.yaml` の抜粋です。主要なライブラリは下記を含みます。

- **provider**: 状態管理
- **http**: GitHub API への HTTP 通信
- **url_launcher**: 外部ブラウザまたはアプリ内ブラウザでリンクを開く
- **flutter_markdown**: README を Markdown 形式でレンダリング
- **flutter_svg**: SVG 画像をレンダリング

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  http: ^1.2.2
  url_launcher: ^6.1.7
  flutter_markdown: ^0.7.5
  flutter_svg: ^2.0.17
```

### 開発環境

- **Flutter**: 3.5.4
- **Dart**: 同梱バージョン
- 状態管理: **provider** を利用
- 対応OS: iOS 9.0～, Android 4.1～

> **注**: 開発時点で最新の安定版（Flutter 3.5.4）を使用。別のバージョンを使う場合は、`README.md` に理由を記載してください。

### テスト

- 現在、UI テスト / 単体テストの導入はサンプル段階となっています。必要に応じて `test/` ディレクトリを作成し、Provider や Service 層のテストを追加してください。

### ライセンス

本リポジトリはパブリックリポジトリとして公開していません（`publish_to: 'none'` ）。  
利用や転載をご希望の方は別途ご相談ください。

### 株式会社ゆめみ Flutter エンジニアコードチェック課題

このアプリは、以下の課題要件に基づいて作成しました。

- Flutter 最新安定版を利用する
- Provider / Riverpod のいずれかを状態管理に使用（本プロジェクトでは Provider）
- GitHub API の `search/repositories` を利用してリポジトリ検索
- 検索結果の概要表示、および詳細表示（リポジトリ名、オーナーアイコン、プロジェクト言語、スター数、ウォッチ数、フォーク数、イシュー数など）
- マテリアルデザインに準拠
- 詳細画面で README を表示

#### 提出方法

- GitHub の public リポジトリ URL を提示
- その他の提出方法は要相談
- 既存 OSS を提出とする場合などは要相談

#### 評価ポイント

- README の充実度・コードレビューのしやすさ
- Git 運用（commit / branch 戦略）
- コードの簡潔性・可読性・保守性・安全性
- UI/UX（エラー処理、画面回転、ダークモード、多言語対応、アニメーションなど）
- テスト（Unit, UI）
- CI/CD（ビルド、テスト、リント、フォーマットなど）

#### 参考

- [私が（iOS エンジニアの）採用でコードチェックする時何を見ているのか](https://qiita.com/lovee/items/d76c68341ec3e7beb611)
- [ゆめみの Android の採用コーディング試験を公開しました](https://qiita.com/blendthink/items/aa70b8b3106fb4e3555f)

### 貢献方法 (Contributing)

Pull Request や Issue を歓迎します。バグ報告・機能改善の提案がある場合は、Issue を立てて議論してください。

### 連絡先

*ここにご自身の連絡先（GitHub アカウントや Twitter など）を書いても OK です*

---

## English Version

### Project Overview

This project is based on the [code-check assignment](#requirements-from-yumemi-flutter-engineer-codecheck-assignment) given by [Yumemi Inc.](https://www.yumemi.co.jp/) for candidates applying for a Flutter Engineer position.  
It is a Flutter application that searches GitHub repositories and displays detailed information (stars, watchers, forks, issues, README, etc.).

### Demo / Screenshots

*Feel free to attach screenshots or GIF animations as needed to illustrate how the app looks and operates (e.g., dark mode and light mode).*

### Main Features
- Search GitHub repositories by keywords
- Advanced search options (owner name, language, license, sorting, etc.)
- Detailed repository information (owner icon, repository name, star count, watchers, forks, open issues, main language, license, etc.)
- Display repository's README in Markdown
- Supports Dark Mode

### Folder Structure

```plaintext
.
├── main.dart
├── models
│   └── repository.dart
├── providers
│   └── repository_provider.dart
├── screens
│   ├── detail_screen.dart
│   └── search_screen.dart
├── services
│   └── github_api_service.dart
├── utils
│   ├── constants.dart
│   └── license_utils.dart
└── widgets
    └── repository_list_item.dart
```

- **main.dart**  
  Entry point of the application. Sets up the `MaterialApp` and providers.
- **models/**  
  Defines domain models such as the `Repository` class.
- **providers/**  
  Holds state management logic, such as `RepositoryProvider`, using `ChangeNotifier`.
- **screens/**  
  UI screens for the app: search (`search_screen.dart`) and detail (`detail_screen.dart`).
- **services/**  
  Services that handle API calls or business logic, such as `github_api_service.dart`.
- **utils/**  
  Utility classes such as `constants.dart` and `license_utils.dart`.
- **widgets/**  
  Reusable custom widgets, like `repository_list_item.dart` for displaying search results.

### Getting Started / Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/flutter_engineer_codecheck.git
   cd flutter_engineer_codecheck
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

    - You can run it on an Android emulator/device or iOS simulator/device.
    - Make sure an emulator or physical device is connected when executing the command.

### Dependencies

Below is an excerpt from `pubspec.yaml`. Main libraries include:

- **provider**: State management
- **http**: For HTTP communication with GitHub API
- **url_launcher**: To open links in an external or in-app browser
- **flutter_markdown**: To render README in Markdown format
- **flutter_svg**: To render SVG images

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  http: ^1.2.2
  url_launcher: ^6.1.7
  flutter_markdown: ^0.7.5
  flutter_svg: ^2.0.17
```

### Development Environment

- **Flutter**: 3.5.4
- **Dart**: version included with Flutter 3.5.4
- State Management: **provider**
- Supported OS: iOS 9.0+, Android 4.1+

> **Note**: We used the latest stable version of Flutter (3.5.4) at the time. If you use a different version, please state your reasons in the `README.md`.

### Testing

- As of now, this project has minimal or example tests. Feel free to set up UI and unit tests in a `test/` directory, especially for Provider and Service layers.

### License

This repository is not published to pub.dev (`publish_to: 'none'`).  
Contact us if you wish to use or redistribute this project.

### Requirements from Yumemi Flutter Engineer CodeCheck Assignment

This application was developed in accordance with the following requirements:

- Use the latest stable version of Flutter
- Use Provider or Riverpod for state management (this project uses Provider)
- Implement GitHub API calls (`search/repositories`) manually (without using packages like `github`)
- Display a list of repository summaries and a detail page (repository name, owner icon, primary language, star count, watchers, forks, issues, etc.)
- Follow Material Design guidelines
- Display the README content on the detail screen

#### Submission

- Provide the public GitHub repository URL
- Other methods of submission are negotiable
- If you would like to submit an existing OSS project as an alternative, please consult with us

#### Evaluation Criteria

- Ease of review:
    - Quality of the README, code comments, and use of GitHub PRs, etc.
- Git management:
    - Proper `.gitignore` settings
    - Appropriate commit granularity
    - Branching strategy
- Code:
    - Simplicity, readability, safety, maintainability
    - Proper use of Dart language features
- UI/UX:
    - Error handling
    - Screen rotation and responsiveness
    - Use of themes, dark mode support
    - Localization
    - Animations
- Tests:
    - Structure that facilitates tests
    - Availability of unit tests or UI tests
- CI/CD:
    - Build, test, lint, format
    - Provisioning for deployment

#### References

- [What I check when I do code reviews for iOS engineers (Japanese)](https://qiita.com/lovee/items/d76c68341ec3e7beb611)
- [We published Yumemi’s Android coding test (Japanese)](https://qiita.com/blendthink/items/aa70b8b3106fb4e3555f)

### Contributing

We welcome pull requests and issues. If you encounter bugs or have feature requests, please open an issue for discussion.

### Contact

*You can place your contact details (GitHub, Twitter, etc.) here if you wish.*

```
