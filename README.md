# AozoraTxt
[青空文庫](https://www.aozora.gr.jp/)で公開されている文書の全テキストファイルのリポジトリです。著作権が存在するファイルは除いてあります。

https://github.com/aozorabunko/aozorabunko で公開されているものをベースにしています。

## ディレクトリ構成
- person/<作者ID>/<作品ID>\_\<type>_<オリジナルファイル名>.txt  
  zipファイルに格納されているファイルそのままです。文字コードはSJIS、改行コードはCRLFです。
- person_utf8/<作者ID>/<作品ID>\_utf8\_\<type>\_<オリジナルファイル名>.txt  
  オリジナル版の文字コードをUTF8に変換し、外字も可能な限りUTF8に置き換えています。改行コードはLNです。

  - <作者ID> : 6桁の数値（先頭0埋め）
  - <作品ID> : 1~5桁の数値
  - \<type> : rubyまたはtxtであり、それぞれルビ入り、ルビ無しを示す。
  - <オリジナルファイル名> : zipファイル内のtxtファイル名。

https://www.aozora.gr.jp/cards/<作者ID>/card<作品ID>.html  
で該当作品の図書カードにアクセスできます。（IDを二つ入れないといけないのがちょっと難点ですね）

## テキストファイルの更新履歴
青空文庫のリポジトリは2011年5月から現在までほぼ毎日更新されていますが、この間に更新されたテキストファイルの変更はすべて本リポジトリに反映してあります。ファイル名の変更もトレースしています（バグがなければ）。

よって、任意のテキストファイルの差分を見れば、2011年以降の更新履歴を確認することができます。とはいえ、多くのファイルは公開後一度も更新されておらず、一番更新が多いファイルでも7世代となります。

## 本リポジトリの更新頻度
本リポジトリン更新作業は手動で行っており、不定期です。