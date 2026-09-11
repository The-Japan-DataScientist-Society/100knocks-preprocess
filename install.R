install.packages(
  # recipesはconda-forge由来のバージョンがthemisの要求する内部関数を含まないビルドのため、CRAN版で明示的に上書きする
  c("DBI", "RPostgreSQL", "recipes", "themis"),
  dependencies = TRUE,
  error = TRUE,
  repos = "https://cran.r-project.org"
)
