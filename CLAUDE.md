# CLAUDE.md

このファイルは、このリポジトリでClaude Code (claude.ai/code) が作業する際のガイダンスを提供します。

## プロジェクト概要

キノコ伝説プレイヤー向けのWebツール集です。GitHub Pagesでデプロイされ、ブラウザ上で完全に動作する複数のスタンドアロンツールで構成されています。

## 開発コマンド

### Ruby開発
```bash
# 依存関係のインストール
bundle install

# リント実行
bundle exec rubocop

# 自動修正可能なリント問題の修正
bundle exec rubocop -a
```

### テスト
- 自動テストスイートは存在しません
- HTMLファイルをブラウザで開いて手動テストが必要
- Ruby WASMツールは特にブラウザ環境でのテストが必要

## アーキテクチャ

### 技術スタック
- **フロントエンド**: HTML5、Materialize CSS 2.0.3-alpha、JavaScript
- **ブラウザ内Ruby**: @ruby/3.3-wasm-wasiを使用してクライアントサイドでRuby実行
- **ビルドプロセス無し**: 全ファイルを直接配信、依存関係はCDNから読み込み

### ツール構造
各ツールは独自のディレクトリに自己完結:
- `index.html` - エントリーポイント
- `index.js` またはRubyファイル - ロジック  
- `index.css` - ツール固有のスタイル（必要に応じて）

### 共有コンポーネント
- `components/base.js` - 全ツール共通のヘッダーとCSS/JS読み込み
- ツール間で共通のMaterialize CSSフレームワーク

### Ruby WASMアーキテクチャ
RubyツールはMVCパターンを使用:
- **Model**: 計算ロジック（例: `Calculator`クラス）
- **View**: DOMHelperライブラリを使用したDOM操作クラス
- **Controller**: 最小限 - 主にビュークラス内

## 重要なファイル

### 設定
- `.rubocop.yml` - Ruby 3.3.4を対象としたRubyスタイル設定
- `.tool-versions` - asdfバージョン管理（Ruby 3.3.4）
- `Gemfile` - 開発依存関係のみ（rubocop）

### 現在の開発状況
- `feature/quiz`ブランチで作業中
- クイズツールをJavaScriptからRuby WASMに移行中
- `quiz_ruby/`に新しいRuby実装が含まれる

## 開発パターン

### Ruby開発
- ブラウザでWASM経由で動作するRubyコードを記述
- RubyからのDOM操作にはDOMHelperライブラリを使用
- 複雑なツールではMVC分離に従う
- 外部ライブラリ読み込み: `Element.call(:importScript, "library_url")`

### JavaScript開発
- Materialize以外のフレームワークを使わないバニラJavaScript
- UI操作のためのイベント駆動プログラミング
- クイズ問題のJSON データ読み込み

### スタイリング
- Materialize CSSグリッドシステム（s12、m6、l4クラス）
- UI要素にMaterial Icons
- ナビゲーションの一貫したamber darken-1カラースキーム

## ツール別の注意事項

### 突破計算機（`rush_calc/`）
- Rubyでの複雑な計算ロジック
- 順次読み込まれる複数のRubyファイルを使用
- CalculatorとViewクラスによるオブジェクト指向設計

### クイズツール
- `quiz/` - 元のJavaScript版
- `quiz_ruby/` - 新しいRuby WASM版（開発中）
- ふりがなサポート付きのJSON形式クイズデータ

### スケジュールツール
- HTML/CSSは完成しているが機能は無効
- ゲームイベントスケジューリング用途

## デプロイ
- GitHub Pages経由での静的ホスティング
- ビルドプロセス不要
- 全依存関係はCDNから読み込み
- 本番デプロイにはmainブランチを使用