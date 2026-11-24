# 本リポジトリで作業する際のガイド

`CLAUDE.md`、`AGENTS.md`、`.github/copilot-instructions.md`はrulesyncで生成しています。
直接編集せず、`.rulesync/rules/`を編集してから`npx rulesync generate`を実行してください。

## ノートブックの実行（テスト相当）

```bash
# ノートブックを1本だけ CI と同じ方法で実行する（docker/work からの相対パスで指定）
docker compose exec -T notebook bash -c "cd work && jupyter nbconvert --to notebook --execute --NotebookClient.allow_error_names UsageError answer/ans_preprocess_knock_Python.ipynb"
```

実行結果は `*.nbconvert.ipynb` として出力される。
CI では、実行結果に `unexpected` という文字列（SQLAlchemy の `MetaData(bind=...)` 系エラー）が含まれると失敗にしている。

## セキュリティ

JupyterLab はトークン認証を無効にしており、ポートは `127.0.0.1` にのみ公開している。`docker-compose.yml` のポート設定を変更して外部ネットワークに公開しないこと。

## DB 接続とデータ投入の注意点

- notebook コンテナからの接続先ホスト名は `db`。接続情報は環境変数 `PG_PORT` / `PG_USER` / `PG_PASSWORD` / `PG_DATABASE` で渡す。
- `docker/db/init/` の初期化スクリプト（ユーザー作成 → テーブル作成 → CSV の `COPY`）は、DB ボリュームが空のときだけ実行される。CSV やスキーマを変更したら、コンテナを作り直す必要がある。

## ノートブック

`docker/work/` 直下の問題ノートブックと、`docker/work/answer/` 内の解答ノートブックは1対1で対応している。最初のコードセル（初期設定・インポート）は両者で同一内容を持つ。問題ノートブックでは演習用に配置されたインポートが使用されていないため `# noqa: F401` を付与している。

- **Python** — 最初のセルは、環境変数 `PG_PORT` があれば DB から読み込む。なければ Colab / SageMaker Studio Lab 向けのフォールバックとして、リポジトリを `git clone` して CSV を `dtype=str` 付きで読む。この分岐は両方とも維持すること。
- **SQL** — JupySQL を使う。問題ノートブックの空の `%%sql` セルは `UsageError` になるが、これは想定どおりの挙動（CI でも許容している）。

## 依存関係の管理

Python パッケージを追加する際は、`Pipfile` と `environment.yml` の両方に記載する必要がある。`fix_env.yml` ワークフローは、`Pipfile` にあって `environment.yml` にないパッケージがあるとエラーにする。また、両ファイルのバージョンを自動修正する PR を作成する。

## Lint（ローカル実行）

```bash
uvx --with black nbqa black docker/work/preprocess_knock_Python.ipynb docker/work/answer/ans_preprocess_knock_Python.ipynb
uvx --with isort nbqa isort docker/work/preprocess_knock_Python.ipynb docker/work/answer/ans_preprocess_knock_Python.ipynb
uvx --with flake8 nbqa flake8 docker/work/preprocess_knock_Python.ipynb docker/work/answer/ans_preprocess_knock_Python.ipynb --max-line-length=300
uvx --with pylint nbqa pylint docker/work/preprocess_knock_Python.ipynb docker/work/answer/ans_preprocess_knock_Python.ipynb --rcfile=.github/linters/.python-lint
```

## Dockerfile の注意点

Dockerfile 内の setuid/setgid ビットの除去や不要キャッシュの削除は、dockle の指摘に対応するためのもの。削除しないこと。

## 過去のレビューで指摘された点

同じ指摘を繰り返さないよう、過去の PR のレビューで指摘された点をまとめる。

- 本リポジトリへの PR では、問題ノートブックに解答を書かない。解答は `docker/work/answer/` の解答ノートブックに置く（利用者が手元で問題を解くときに、問題ノートブックへ書き込むのは問題ない）。
- 解答コードの書き方は、いろいろな書き方を知ってもらうためにあえて統一していない（属性アクセスと `[]` の混在、コメントで説明するために残している `regex=True` など）。書き方を揃えるだけの変更はしない。
- 正式に対象としていない環境（Azure Notebooks など）向けのファイルや、エディタ・IDE の設定（`.devcontainer`、`.vscode` など）は追加しない。ツールの選択は利用者に任せている。
- ディレクトリ構成やファイル名を変えない。外部の解説サイトや `docker/doc/` のガイド PDF が、今の構成を前提にしている。
- notebook コンテナには、`docker/work` と `docker/doc` だけをマウントする。`docker/db/` は環境構築のためだけのものなので、JupyterLab から見せない。
- 環境構築の手順や構成を変えたら、`README.md` とガイド PDF の記述と食い違わないか確認し、食い違う場合は PR の本文に書く。
- イメージの内容は Dockerfile に、接続情報などの実行時の設定は `docker-compose.yml` に置く。
- notebook イメージは、amd64 と arm64（Apple Silicon の Mac）の両方でビルドできるようにする。
- ノートブックは Docker 環境で実行し直してからコミットする。SageMaker Studio Lab などで保存すると kernelspec が書き換わり、CI でカーネルが見つからず失敗する。kernelspec の `name` は Python と SQL が `python3`、R が `ir`。
- CSV は BOM 付きのため、pandas で読むときは `encoding="utf-8-sig"` を指定する。
- hadolint や ShellCheck の指摘を無効化するときは、必要な最小の範囲で無効化する。該当箇所だけで済むなら、`# shellcheck disable=SC2016` のようにその箇所だけで無効化する。リポジトリ全体で当てはまらないルールなら、設定ファイルでルールごと無効化してよい。
