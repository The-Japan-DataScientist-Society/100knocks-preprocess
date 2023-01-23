Name
====
データサイエンス100本ノック（構造化データ加工編）

Overview
====
- データサイエンス100本ノック（構造化データ加工編）を実践するための演習問題とデータ、および環境構築のためのスクリプト一式
- 演習問題はSQL、Python、Rで共通
- 言語によっては向かない設問もあるが、「この言語のときはこう書けば実現できる」という技術習得を目指すことを優先
- 個人情報のように見える項目は全てダミーデータを利用
- 大学、企業など組織でのご利用にあたっては、「データサイエンティスト協会スキル定義委員」の「データサイエンス100本ノック（構造化データ加工編）」を利用していることを明示いただければ自由に利用してOK
- データサイエンス100本ノック(構造化データ加工編)の解説本はこちら
   - https://www.amazon.co.jp/dp/4802613563
- データサイエンス100本ノック(構造化データ加工編)の利用に関するご質問等について、個別での対応は受けかねますので予めご了承ください
- データサイエンス100本ノック(構造化データ加工編)の利用により生じるいかなる問題についても、当協会は一切の責任を負いかねますのであらかじめご了承ください

Description
====
- Dockerfile(dockerfiles/notebook/Dockerfile, dockerfiles/notebook/Dockerfile)
- docker-compose.yml
- スーパーの架空購買データと架空個人情報(csv)
- データベースを初期設定するための各種スクリプト
- 設問と解答例のノートブックファイルおよびHTMLファイル

Requirement
====

- Local
    - Docker Desktop(Windows 10/11, macOS)
    - Apple M1チップ搭載のMacの場合は Docker Desktop 4.4.2 以降
    - WindowsのHome EditionでもWSL2をインストールすることでDocker Desktopが使えるようになりました！
- Cloud Service
    - `Amazon SageMaker Studio Lab <https://studiolab.sagemaker.aws/>`_ (`使い方 <https://github.com/aws-sagemaker-jp/awesome-studio-lab-jp/blob/main/README_usage.md>`_)
        - Python演習: |Open in SageMaker Studio Lab Practice| Python解答: |Open in SageMaker Studio Lab Answer|
    - `Colaboratory <https://colab.research.google.com/>`_
        - Python演習: |Open in Colab Practice| Python解答: |Open in Colab Answer|


.. |Open in SageMaker Studio Lab Practice| image:: https://studiolab.sagemaker.aws/studiolab.svg
   :target: https://studiolab.sagemaker.aws/import/github/The-Japan-DataScientist-Society/100knocks-preprocess/blob/master/docker/work/preprocess_knock_Python.ipynb

.. |Open in SageMaker Studio Lab Answer| image:: https://studiolab.sagemaker.aws/studiolab.svg
   :target: https://studiolab.sagemaker.aws/import/github/The-Japan-DataScientist-Society/100knocks-preprocess/blob/master/docker/work/answer/ans_preprocess_knock_Python.ipynb

.. |Open in Colab Practice| image:: https://colab.research.google.com/assets/colab-badge.svg
   :target: https://colab.research.google.com/github/The-Japan-DataScientist-Society/100knocks-preprocess/blob/master/docker/work/preprocess_knock_Python.ipynb

.. |Open in Colab Answer| image:: https://colab.research.google.com/assets/colab-badge.svg
   :target: https://colab.research.google.com/github/The-Japan-DataScientist-Society/100knocks-preprocess/blob/master/docker/work/answer/ans_preprocess_knock_Python.ipynb

Install
====

::

 git clone git@github.com:The-Japan-DataScientist-Society/100knocks-preprocess.git
 cd 100knocks-preprocess
 docker compose up -d --build --wait

※ macOSでユーザーのホームディレクトリ配下以外にファイル群を配置する場合、Dockerの共有設定が別途必要となります

※ Windowsでgitを利用する場合、デフォルト設定でのインストールを行うとスクリプトの改行コードを変えられてしまい、データベースを正しく構築できないことがあります https://github.com/The-Japan-DataScientist-Society/100knocks-preprocess/issues/1#issue-640590032

※ 改行を変えないよう設定するか、ZIPをダウンロードして利用してください

※ コンテナは作成されたがデータベースに接続できない、という場合の多くはディレクトリに対するアクセス権限設定の問題となります

※ インストールの説明はdoc配下の説明資料も参照してください

Usage
====
- ブラウザで以下のURLにアクセスします
http://localhost:8888

How to contribute
====
開発に協力していただける場合は本リポジトリをcloneし、 https://pre-commit.com/ の手順に従って `pre-commit` をインストールしてください。

これにより、 `.pre-commit-config.yaml <.pre-commit-config.yaml>`_ の設定に基づいて、コミット時にクレデンシャルが含まれていないかの検査が行われるようになります。

Document
====
- doc配下にデータサイエンス100本ノック（構造化データ加工編）の説明資料と設問PDF、設問HTML、解答例HTMLを配置
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

- データサイエンス初学者にむけた、データサイエンス100本ノックを実装する方法（windows10 Home向け）
   - https://qiita.com/syuki-read/items/714fe66bf5c16b8a7407#comment-394d2f7656bd5b977e11

Author
====
The Data Scientist Society

LICENSE
====
- docker/doc/100knocks_guide.pdfは協会ロゴ等が含まれるため、CC-BY-NDとなります
- その他ファイルはMITライセンスに従います
