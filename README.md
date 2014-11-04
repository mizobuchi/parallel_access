parallel_access
===============

server.infoで設定した複数のサーバに対し，並列でコマンドを実行します．
与えられたコマンドを一行ずつ実行し，全てのサーバでの処理が終了すると次の行のコマンドを実行します．

```実行コマンド例
ruby parallel_access.rb < commands.csv
```