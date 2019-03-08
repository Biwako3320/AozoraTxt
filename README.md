# AozoraTxt
[青空文庫](https://www.aozora.gr.jp/)で公開されている文書の全テキストファイルのリポジトリです。著作権が存在するファイルは除いてあります。

https://github.com/aozorabunko/aozorabunko で公開されているものをベースにしています。

## ディレクトリ構成
- person/<作者ID>/<作品ID>\_\<type>_<オリジナルファイル名>.txt  
  ファイル名は異なりますが、zipファイルに格納されているファイルそのままです。文字コードはSJIS、改行コードはCRLFです。
- person_utf8/<作者ID>/<作品ID>\_utf8\_\<type>\_<オリジナルファイル名>.txt  
  オリジナル版の文字コードをUTF8に変換し、外字も可能な限りUTF8に置き換えています。改行コードはLFです。

  - <作者ID> : 6桁の数値（先頭0埋め）
  - <作品ID> : 1~5桁の数値
  - \<type> : rubyまたはtxtであり、それぞれルビ入り・ルビ無しを示します。古いファイルでは一つの作品に対してルビ入り・ルビ無しの両方が作成されることがありましたが、現在では底本にルビがあればルビ入り、無ければルビ無しとなります。
  - <オリジナルファイル名> : zipファイル内のtxtファイル名。

https://www.aozora.gr.jp/cards/<作者ID>/card<作品ID>.html  
で該当作品の図書カードにアクセスできます。（IDを二つ入れないといけないのがちょっと難点ですね）

## テキストファイルの更新履歴
青空文庫のリポジトリは2011年5月から現在までほぼ毎日更新されていますが、この間に変更されたテキストファイルの差分はすべて本リポジトリに反映してあります（バグがなければ）。ファイル名の変更もトレースしています。

よって、任意のテキストファイルの差分を見れば、2011年以降の更新履歴を確認することができます。とはいえ、多くのファイルは公開後一度も更新されておらず、一番更新が多いファイルでも7世代となります。

## 本リポジトリの更新頻度
本リポジトリの更新作業は手動で行っており、不定期です。

## UTF8版における外字のUnicode変換
例の右側に示すような[青空文庫記法](https://www.aozora.gr.jp/annotation/external_character.html)による外字は対応するUnicode文字に変換してあります。
- 𣘹　：　※［＃「木＋寅」、第4水準2-15-31］
- 怰　：　※［＃「りっしんべん＋玄」、U+6030、418-3-22］
- ‼　：　※［＃感嘆符二つ、1-8-75］

以下のような青空文庫記法における特殊文字は外字変換の対象外となっています。
- 《　：　※［＃始め二重山括弧、1-1-52］
- 》　：　※［＃終わり二重山括弧、1-1-53］
- ［　：　※［＃始め角括弧、1-1-46］
- ］　：　※［＃終わり角括弧、1-1-47］
- 〔　：　※［＃始めきっこう（亀甲）括弧、1-1-44］
- 〕　：　※［＃終わりきっこう（亀甲）括弧、1-1-45］
- ｜　：　※［＃縦線、1-1-35］
- ＃　：　※［＃井げた、1-1-84］
- ※　：　※［＃米印、1-2-8］
