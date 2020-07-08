Name
====
データサイエンス100本ノック（構造化データ加工編）

Overview
====
- データサイエンス100本ノック（構造化データ加工編）を実践するための演習問題とデータ、および環境構築のためのスクリプト一式
- 演習問題はSQL、Python、Rで共通
- 言語によっては向かない設問もあるが、「この言語のときはこう書けば実現できる」という技術習得を目指すことを優先
- 個人情報のように見える項目は全てダミーデータを利用
- 大学、企業など組織でのご利用にあたっては、「データサイエンティスト協会スキル定義委員」の「データサイエンス100本ノック（構造化データ加工編）」を利用していることを明示いただければ自由に利用してOK（これがどんなライセンス形態に当てはまるかは近々整理します）
- データサイエンス100本ノック(構造化データ加工編)の利用に関するご質問等について、個別での対応は受けかねますので予めご了承ください
- また、データサイエンス100本ノック(構造化データ加工編)の利用により生じるいかなる問題についても、当協会は一切の責任を負いかねますのであらかじめご了承ください。

Description
====
- Dockerfile(Dockerfile.notebook, Dockerfile.postgres)
- docker-compose.yml
- スーパーの架空購買データと架空個人情報(csv)
- データベースを初期設定するための各種スクリプト

Requirement
====
- Docker(Windows 10 proffesional Edition, macOS)
- Docker Toolbox(Windows 10 home edition)

Install
====
- $ git clone [Repository URL] ※
- $ cd 100knocks-preprocess
- $ docker-compose up -d --build

※ OSユーザーのホームディレクトリ配下以外にダウンロードする場合、Dockerの共有設定が別途必要となります

※ Windowsでgitを利用する場合、デフォルト設定でのインストールを行うとスクリプトの改行コードを変えられてしまい、データベースを正しく構築できないことがあります
- https://github.com/The-Japan-DataScientist-Society/100knocks-preprocess/issues/1#issue-640590032

※ 改行を変えないよう設定するか、ZIPをダウンロードして利用してください

※ インストールの説明はdoc配下の説明資料も参照してください

Usage
====
- Docker Desktopの場合
http://localhost:8888

- Docker Toolboxの場合
http://192.168.99.100:8888

Document
====
- doc配下にデータサイエンス100本ノック（構造化データ加工編）の説明資料と設問PDF、設問HTMLを配置
- work配下に設問notebookを配置
- work/answer配下に解答例notebookを配置
- work/data配下に使用したデータを配置

Link
====
本コンテンツの内容やセットアップ手順について解説いただいているサイト、Dockerについて基本から学べるサイト
- 【データサイエンスを学ぶあなたへ】100本ノック - 構造化データ処理編 - 最速レビュー動画！【データサイエンティスト協会】#062
  - https://www.youtube.com/watch?v=fAyj0V2iAc4
- データサイエンス100本ノック（構造化データ加工編）を試してみた
  - https://qrunch.net/@hanar/entries/kSZfFS1MXK8H7U7x
- Macでデータサイエンス100本ノックを動かす方法
  - https://qiita.com/karaage0703/items/1b18b1f4ab65d35afb5f
- さくらのナレッジ
  - https://knowledge.sakura.ad.jp/13265/
- データサイエンス100本ノックを、Google ColabとAzure Notebooksで気軽に行いたい！
  - https://qiita.com/noguhiro2002/items/de49db61b69c3dbc9282

## Author
The Data Scientist Society
