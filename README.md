Name
====
Google Colab, Azure Notebooks移植版：データサイエンス100本ノック（構造化データ加工編）

Overview
====
 - Originalのデータサイエンス100本ノック（構造化データ加工編）はDocker形式で提供されており、実践的な演習が可能である一方でお手軽感はない。
 - より気軽に100本ノックするため、Google Colabと、Azure Notebookで実行できる演習スクリプトと、解答編スクリプトを提供する。Pythonのみである。
 - オリジナルの解答編で実行できなかったセルと、オリジナルのCSV(geocode.csv)で明らかに間違っている列名を訂正。

## Description
 - Google colab用ipynb: https://github.com/noguhiro2002/100knocks-preprocess_ForColab-AzureNotebook/blob/master/preprocess_knock_Python_Colab.ipynb
 
 - Azure Notebook用ipynb: https://github.com/noguhiro2002/100knocks-preprocess_ForColab-AzureNotebook/blob/master/preprocess_knock_Python_Azure.ipynb

 - './data': CSVデータ
 - './answer': 解答例(オリジナルを元に一部訂正)
 - './doc': ドキュメント(オリジナルと同じ)

## Usage: Google Colab
 1. こちらをクリック：https://github.com/noguhiro2002/100knocks-preprocess_ForColab-AzureNotebook/blob/master/preprocess_knock_Python_Colab.ipynb
 2. ipynbファイルプレビューの上部にある「Open in Colab」をクリック。
 3. もしくは、Google Colabの画面上部のファイル -> ノートブックを開く -> 「GitHub」タブを選択 -> 「GitHub URLを入力するか、組織またはユーザーで検索します」に「noguhiro2002/100knocks-preprocess_ForColab-AzureNotebook」と入力し検索 -> 出てきたリストから「preprocess_knock_Python_Colab.ipynb」を開く。解答編は「answer/ans_preprocess_knock_Python_Colab.ipynb」を開く
 4. 100本ノックをお楽しみください。

 
## Usage: Azure Notebooks
 1. Azure Notebooksに接続後、プロジェクトに入ります。なければ、適当なプロジェクトを作成し、入ります。
 2. 「Upload」より、「From URL」を選択します。
 3. File Urlに「https://raw.githubusercontent.com/noguhiro2002/100knocks-preprocess_ForColab-AzureNotebook/master/preprocess_knock_Python_Azure.ipynb 」を入力し、「I trust the contents of this file」にチェックマークを入れ、「Done」をクリック。
 4. 100本ノックをお楽しみください。


## Original
一般社団法人データサイエンス協会
The Data Scientist Society

The-Japan-DataScientist-Society/100knocks-preprocess
https://github.com/The-Japan-DataScientist-Society/100knocks-preprocess

## Arranged the original and author of this repository
noguhiro2002
