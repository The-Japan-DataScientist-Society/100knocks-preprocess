install.packages(
  # recipesはconda-forge由来のバージョンがthemisの要求する内部関数を含まないビルドのため、CRAN版で明示的に上書きする
  c("DBI", "RPostgreSQL", "recipes", "themis"),
  # Suggests(vignette/テスト専用の任意依存)まで含めると、arrow等のビルドに時間がかかる
  # 依存の導入を試みて失敗するため、動作に必要な依存(Depends/Imports/LinkingTo)のみに絞る
  dependencies = c("Depends", "Imports", "LinkingTo"),
  error = TRUE,
  repos = "https://cran.r-project.org"
)
