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

本リポジトリは、学習者が手元で動かす環境と、書き込み権限のあるトークンで動くワークフローを含みます。
実装やレビューでは、正しく動くかに加えて、悪意ある入力や操作に耐えられるかを必ず確認してください。

- JupyterLab はトークン認証を無効にしており、ポートは `127.0.0.1` にのみ公開している。`docker-compose.yml` のポート設定を変更して外部ネットワークに公開しないこと。DB のポートも同様。
- `docker-compose.yml` の DB のパスワードは、ローカルの学習環境専用の固定値である。本物の認証情報を書き込んだり、ノートブックやログに出力したりしない。
- ワークフロー
  - PR のブランチ名やタイトル、PR 内のファイルなどの外部から入る値は、攻撃者が自由に決められるものとして扱う。
  - `run:` や `script:` には `${{ }}` で埋め込まず、`env:` 経由で渡す。シェルでは変数を必ずダブルクォートで囲み、外部から入る値を `eval` や文字列からのコマンド組み立てに使わない。
  - `GITHUB_ENV` や `GITHUB_OUTPUT` に外部から入る値を書き込む場合は、改行で別の値を注入されないよう、ランダムな delimiter の heredoc 形式で書き込む。
  - `permissions` は必要最小限にし、`actions/checkout` には `persist-credentials: false` を付ける。`pull_request_target` や `workflow_run` で PR のコードを書き込み権限付きで実行しない。
  - トークンをログやエラーメッセージに出さない。
- 新しい外部の Actions はコミットハッシュで固定し、`.github/workflows/actions.lock` を更新する。依存パッケージは、公開から日が浅い版を避ける。
- ノートブックの Colab / SageMaker Studio Lab 向けフォールバックで `git clone` する先は、本リポジトリの公式 URL から変えない。
- レビューで脆弱性を見つけた場合は、公開の Issue や PR に詳細を書かず、まず報告する。

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
