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
   `git clone https://github.com/your-username/flutter_engineer_codecheck.git`  
   `cd flutter_engineer_codecheck`

2. **依存関係をインストール**  
   `flutter pub get`

3. **アプリを実行**  
   `flutter run`

    - Android シミュレータ / 実機、または iOS シミュレータ / 実機で起動可能です。
    - エミュレータや実機が接続された状態でコマンドを実行してください。

### 依存関係

- **provider**: 状態管理
- **http**: GitHub API への HTTP 通信
- **url_launcher**: 外部ブラウザまたはアプリ内ブラウザでリンクを開く
- **flutter_markdown**: README を Markdown 形式でレンダリング
- **flutter_svg**: SVG 画像をレンダリング

### 開発環境

- **Flutter**: 3.5.4
- **Dart**: version included with Flutter 3.5.4
- 状態管理: **provider**
- 対応OS: iOS 9.0+, Android 4.1+

> **注**: 開発時点で最新の安定版（Flutter 3.5.4）を使用。別のバージョンを使う場合は、`README.md` に理由を記載してください。

### ライセンス

本リポジトリはパブリックリポジトリとして公開していません（`publish_to: 'none'` ）。  
利用や転載をご希望の方は別途ご相談ください。

---

## English Version

### Project Overview

This project is based on the [code-check assignment](#requirements-from-yumemi-flutter-engineer-codecheck-assignment) given by [Yumemi Inc.](https://www.yumemi.co.jp/) for candidates applying for a Flutter Engineer position.  
It is a Flutter application that searches GitHub repositories and displays detailed information (stars, watchers, forks, issues, README, etc.).

### Main Features

- Search GitHub repositories by keywords
- Advanced search options (owner name, language, license, sorting, etc.)
- Detailed repository information (owner icon, repository name, star count, watchers, forks, open issues, main language, license, etc.)
- Display repository's README in Markdown
- Supports Dark Mode

### Folder Structure

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

### Setup / Installation

1. **Clone the repository**  
   `git clone https://github.com/your-username/flutter_engineer_codecheck.git`  
   `cd flutter_engineer_codecheck`

2. **Install dependencies**  
   `flutter pub get`

3. **Run the app**  
   `flutter run`

    - Works with Android emulators/devices or iOS simulators/devices.

### Development Environment

- **Flutter**: 3.5.4
- **Dart**: version included with Flutter 3.5.4
- State Management: **provider**
- Supported OS: iOS 9.0+, Android 4.1+

### License

This repository is not published to pub.dev (`publish_to: 'none'`).  
Contact us if you wish to use or redistribute this project.
