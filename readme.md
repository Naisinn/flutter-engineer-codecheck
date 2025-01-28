# Github検索

## 概要
**Github検索**は、GitHubリポジトリを検索し、詳細情報（スター数、ウォッチ数、フォーク数、イシュー数、READMEなど）を確認できるFlutterアプリです。  
ユーザーはキーワードやオーナー名、プログラミング言語、ライセンスなどのフィルタを使用して、目的のリポジトリを効果的に検索できます。  
さらに、**ダークモード**と**英語表示**にも対応しており、ユーザーの好みに合わせてインターフェースをカスタマイズできます。

## スクリーンショット(実機より赤みがかっています)
| 検索画面 | 検索結果 | 詳細画面 | ダークモード |
| --- | --- | --- | --- |
| ![Github検索_検索画面.jpg](assets/Github検索_検索画面.jpg) | ![Github検索_検索結果.jpg](assets/Github検索_検索結果.jpg) | ![Github検索_詳細画面.jpg](assets/Github検索_詳細画面.jpg) | ![Github検索_ダークモード.jpg](assets/Github検索_ダークモード.jpg) |


## インストール方法
以下の手順に従って、**Github検索**アプリケーションをローカル環境にセットアップしてください。

### 前提条件
- [Flutter](https://flutter.dev/docs/get-started/install) がインストールされていること
- Gitがインストールされていること

### 手順
1. **リポジトリのクローン**

   ```bash
   git clone https://github.com/your-username/github-search.git
   cd github-search
   ```

2. **依存パッケージのインストール**

   Flutterプロジェクトのルートディレクトリで、以下のコマンドを実行して必要なパッケージをインストールします。

   ```bash
   flutter pub get
   ```

3. **アプリケーションの実行**

   接続されたデバイスまたはエミュレーターでアプリケーションを実行します。

   ```bash
   flutter run
   ```

## 使用方法
1. **アプリ起動**  
   アプリケーションを起動すると、検索画面が表示されます。

2. **言語設定**  
   端末の設定に応じて、アプリケーションの言語が自動的に設定されます。

3. **テーマ設定**  
   端末の設定に応じて、アプリケーションのテーマ（ライトモード・ダークモード）が自動的に設定されます。

4. **基本的な検索**
    - *検索キーワード入力*  
      検索バーにリポジトリを探すためのキーワードを入力します。
    - *検索ボタン*  
      入力が完了したら、「検索」ボタンをタップする、あるいはキーボードのEnterをタップしてリポジトリを検索します。

5. **高度な検索**  
   検索フォームの折りたたみメニューから、より詳細な検索オプションを指定できます。
    - *オーナー名*  
      特定のユーザー名を入力して、そのユーザーが所有するリポジトリに絞り込むことができます。
    - *プログラミング言語*  
      指定した言語（Dart、JavaScriptなど）のリポジトリに絞り込みます。
    - *ライセンス*  
      プルダウンからMITやGPLなどのライセンスを選択できます。ここで「Any」を選択するとライセンスフィルタを適用しません。
    - *ソート基準・ソート順*  
      「スター数」や「フォーク数」など、ソート基準を指定できます。ソート順は降順・昇順の選択が可能です。

6. **検索結果の一覧表示**
    - 検索結果がリスト形式で表示されます。
    - 各リポジトリの項目には、リポジトリ名、オーナー名、言語、ライセンス、スター数などが表示されます。
    - リポジトリ項目をタップすると詳細画面に遷移します。

7. **詳細画面でできること**
    - **オーナーアバターと基本情報**  
      上部にオーナーのアバターが表示され、リポジトリ名やオーナー名を確認できます。
    - **スター数・ウォッチ数・フォーク数・イシュー数の確認**  
      アイコン付きで表示されており、タップするとポップアップで説明を確認できます。
    - **プログラミング言語**  
      リポジトリの主な言語が表示されます。
    - **ライセンス**  
      ライセンス情報がアイコンと略称で表示され、タップするとライセンスの公式ページなどの説明ページに移動できます。
        - 初めにアプリ内ブラウザを試み、失敗した場合は外部ブラウザを開きます。
    - **GitHubで開く**  
      「GitHubで開く」ボタンをタップすると、リポジトリのGitHubページをブラウザ（内部ブラウザ→外部ブラウザ）で開きます。
    - **READMEの表示**
        - リポジトリのREADMEをGitHub APIから取得し、Markdown形式で表示します。
        - もしRST形式のREADMEであっても、本文中の画像やリンク、コードブロックなどを一部変換してMarkdownとして表示します。
        - 画像がSVGの場合は、対応してSVGをレンダリングし、他の画像は通常の画像として表示します。
        - README内のリンクをタップすると、やはりアプリ内ブラウザ→外部ブラウザの順に開くようになっています。エラーが起きた場合はスナックバーで通知します。

8. **エラー処理**
    - リポジトリ取得やREADMEの取得時にエラーが発生した場合、画面にエラーメッセージを表示します。
    - リンクを開く際にも失敗時にスナックバーで通知し、外部ブラウザを再試行します。

## 特徴
- **ダークモード対応**  
  ユーザーの好みに合わせてダークモードとライトモードを選択可能です。

- **多言語サポート**  
  日本語と英語に対応しており、ユーザーインターフェースの言語を切り替えることができます。

- **高度な検索機能**  
  キーワード、オーナー名、プログラミング言語、ライセンス、ソート基準など、豊富なフィルタリングオプションを提供します。

- **詳細情報の表示**  
  リポジトリの詳細情報を豊富に表示し、READMEの内容も確認できます。

## ライセンス

このプロジェクトの開発部分はGNU Affero General Public License v3（AGPL v3）の下で提供されています。
元の課題はApache License Version 2.0（Apache 2.0）の下で提供されています。


# GitHub Search

## Overview
**GitHub Search** is a Flutter application that allows you to search GitHub repositories and view detailed information such as the number of stars, watchers, forks, issues, README, and more.  
Users can effectively search for repositories using filters like keywords, owner name, programming language, and license.  
Additionally, **Dark Mode** and **English Display** are supported, allowing users to customize the interface according to their preferences.

## Screenshots（It is more reddish than the actual machine.）
| Search Screen | Search Results | Detail Screen | Dark Mode |
| --- | --- | --- | --- |
| ![Github検索_検索画面_English.jpg](assets%2FGithub%E6%A4%9C%E7%B4%A2_%E6%A4%9C%E7%B4%A2%E7%94%BB%E9%9D%A2_English.jpg) | ![Github検索_検索結果_English.jpg](assets%2FGithub%E6%A4%9C%E7%B4%A2_%E6%A4%9C%E7%B4%A2%E7%B5%90%E6%9E%9C_English.jpg) | ![Github検索_詳細画面_English.jpg](assets%2FGithub%E6%A4%9C%E7%B4%A2_%E8%A9%B3%E7%B4%B0%E7%94%BB%E9%9D%A2_English.jpg) | ![Github検索_ダークモード_English.jpg](assets%2FGithub%E6%A4%9C%E7%B4%A2_%E3%83%80%E3%83%BC%E3%82%AF%E3%83%A2%E3%83%BC%E3%83%89_English.jpg) |

## Installation

Follow the steps below to set up the **GitHub Search** application on your local environment.

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) is installed
- Git is installed

### Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your-username/github-search.git
   cd github-search
   ```

2. **Install Dependencies**

   In the root directory of the Flutter project, run the following command to install the necessary packages.

   ```bash
   flutter pub get
   ```

3. **Run the Application**

   Run the application on a connected device or emulator.

   ```bash
   flutter run
   ```

## Usage

1. **Launch the App**  
   When you launch the application, the search screen will be displayed.

2. **Language Settings**  
   The application's language is automatically set based on the device's settings.

3. **Theme Settings**  
   The application's theme (Light Mode/Dark Mode) is automatically set based on the device's settings.

4. **Basic Search**
   - *Enter Search Keywords*  
     Enter keywords in the search bar to look for repositories.
   - *Search Button*  
     After entering the keywords, tap the "Search" button or press Enter on the keyboard to perform the search.

5. **Advanced Search**  
   From the collapsible menu in the search form, you can specify more detailed search options.
   - *Owner Name*  
     Enter a specific username to filter repositories owned by that user.
   - *Programming Language*  
     Filter repositories by the specified language (e.g., Dart, JavaScript).
   - *License*  
     Select a license such as MIT or GPL from the dropdown. Selecting "Any" will not apply a license filter.
   - *Sort Criteria & Order*  
     Specify sort criteria like "Stars" or "Forks". You can choose the sort order as ascending or descending.

6. **Displaying Search Results**
   - Search results are displayed in a list format.
   - Each repository item shows the repository name, owner name, language, license, number of stars, etc.
   - Tapping on a repository item navigates to the detail screen.

7. **What You Can Do on the Detail Screen**
   - **Owner Avatar and Basic Information**  
     The owner's avatar is displayed at the top, and you can view the repository name and owner name.
   - **View Stars, Watchers, Forks, and Issues**  
     These are displayed with icons, and tapping them shows a popup with explanations.
   - **Programming Language**  
     The main language of the repository is displayed.
   - **License**  
     License information is displayed with an icon and abbreviation. Tapping it navigates to the official license page or an explanation page.
      - The in-app browser is attempted first, and if it fails, an external browser is opened.
   - **Open on GitHub**  
     Tapping the "Open on GitHub" button opens the repository's GitHub page in a browser (in-app browser → external browser).
   - **Display README**
      - The repository's README is fetched from the GitHub API and displayed in Markdown format.
      - If the README is in RST format, some elements like images, links, and code blocks are partially converted and displayed as Markdown.
      - SVG images are rendered if supported; other images are displayed normally.
      - Tapping links within the README opens them in the in-app browser first, then the external browser if necessary. Errors are notified via a snackbar.

8. **Error Handling**
   - If an error occurs while fetching repositories or the README, an error message is displayed on the screen.
   - When opening links, if it fails, a snackbar notifies the user, and an external browser is retried.

## Features
- **Dark Mode Support**  
  Users can choose between Dark Mode and Light Mode according to their preferences.

- **Multilingual Support**  
  Supports both Japanese and English, allowing users to switch the language of the user interface.

- **Advanced Search Functionality**  
  Provides a rich set of filtering options, including keywords, owner name, programming language, license, and sort criteria.

- **Detailed Information Display**  
  Displays comprehensive information about repositories, including the content of the README.


## License

The development part of this project is provided under the [GNU Affero General Public License v3 (AGPL v3)](https://www.gnu.org/licenses/agpl-3.0.en.html).  
The original assignment is provided under the [Apache License Version 2.0 (Apache 2.0)](https://www.apache.org/licenses/LICENSE-2.0).
