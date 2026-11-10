---
root: true
targets:
  - "*"
globs:
  - "**/*"
description: 本リポジトリで作業する際のAIエージェント向けのガイド
---

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
