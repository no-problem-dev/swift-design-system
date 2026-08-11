# 変更履歴

このプロジェクトの全ての重要な変更はこのファイルに記録されます。

フォーマットは [Keep a Changelog](https://keepachangelog.com/ja/1.0.0/) に基づいており、
このプロジェクトは [セマンティックバージョニング](https://semver.org/lang/ja/spec/v2.0.0.html) に準拠しています。

## [未リリース]

**公開 API を壊しています。** `Typography.font` / `Typography.font(design:)` を削除し、
`ThemeProvider.colorPalette` をプロパティからメソッドへ変えました。

### 修正

- **`IconButton` の `.outlined` が線を描くようになった。** 背景色の分岐しか持っておらず、
  `.standard` と 1 画素も違わない絵を出していた。名前だけあって輪郭が無い状態。
  輪郭は `ColorPalette.outline` を `BorderScale.regular`（1pt）で描く。輪郭を持つ他の部品
  （`OutlinedChipStyle` / `GlassButtonStyle`）と同じトークンの組み合わせに揃えた。

- **`ByteSize.formatted` が型と同じ 1,024 進で数えるようになった。** ファクトリも単位換算も
  1,024 進なのに `ByteCountFormatter` だけ 1,000 進（`.file`）で数えていたため、
  `ByteSize.megabytes(100)` が `"104.9 MB"` と表示されていた。`.binary` にして `"100 MB"` になる。

- **`ThemeProvider` のパレット解決が端末の外観に従うようになった。** `themeMode` が `.system` の
  間は、端末が暗くてもライトのパレットを返していた。解決は `.theme(_:)` の中にしか無く、
  プロバイダに直接聞くと必ずライトが返る、という食い違いだった。

### 削除

- **`Typography.font` と `Typography.font(design:)`。** 固定 pt の `.system(size:)` を返すだけで
  Dynamic Type に追随しない。追随するのは `.typography(_:)` モディファイア（環境の
  `TypographyScale` で解決してから `@ScaledMetric` を通す）だけで、`font` は同じものに見えて
  文字が伸びなくなる罠だった。文字を出す経路は `.typography(_:)` に一本化。

### 変更

- **`ThemeProvider.colorPalette` はメソッドになった。** `colorPalette(for:)` が `ColorScheme` を
  受け取り、`.system` をその外観に対して解決する。解決規則そのものは `resolvedMode(for:)` として
  公開した。`.theme(_:)` は環境の `colorScheme` を渡してこれを呼ぶので、解決の置き場所が 1 つになる。

- **同梱している UI 文言を英語にした。** ピッカー（アイコン / 絵文字 / カラー / 画像 / 動画）、
  動画プレイヤー、権限アラート、`VideoPickerError.errorDescription`、`StatusIndicator` と
  `StepIndicator` のアクセシビリティラベル、`ThemeCategory` と各テーマの説明文。
  カタログとプレビューは配布物ではないため対象外。

### 使う側でやること

- `Typography.font` を使っていたら `.typography(_:)` に置き換える
- `provider.colorPalette` を読んでいたら `provider.colorPalette(for: colorScheme)` にする。
  ビューの中なら `@Environment(\.colorPalette)` を読むのが本来の経路

## [2.4.0] - 2026-08-02

**`DefaultTheme` を使っているアプリは、ライトモードの見た目が変わります。**
自前の `ColorPalette` を実装しているアプリは影響を受けません。

### 変更

- **ライトの面の段差を色で作るようにした。** 地とカード面がほぼ同じ明度（1.045:1）で、
  カードの輪郭が実質シャドウだけになっていた。影は光の当たり方の表現なので、暗い場所・
  スクリーンショット・コントラストを上げた設定のどれでも消える。そこに輪郭を預けると、
  条件によってカードが背景に溶ける。

  | トークン | これまで | これから |
  |---|---|---|
  | `background` | `.white` | `gray100` |
  | `surface` | `gray50` | `.white` |
  | `surfaceVariant` | `gray100` | `gray200` |

  **地を沈めて面を白へ置いた。** 逆（地が白・カードが灰）にすると、手前にあるものほど
  暗いという上下関係の逆転が起きる。Apple のグループ化リストも地が灰で面が白。

  | | 面 / 地 |
  |---|---|
  | これまで | 1.045 |
  | **これから** | **1.101** |
  | 参考: Apple iOS ライト | 1.116 |
  | 参考: 本パッケージのダーク | 1.209 |

  ダークは変えていない（元から 1.209 で足りている）。新しい色は足しておらず、
  既存のプリミティブの組み替えだけ。

### 見た目が変わるもの

`surfaceVariant` を下地に使っている部品は、白の上ではっきり見えるようになる。
スナップショットで差分が出たのは次の 6 種（いずれもライトのみ）:

- `Snackbar` の板
- `DSTextField` の `.filled` の塗り
- `ProgressBar` の未達部分のトラック
- `SegmentedControl` のトラック
- `EmptyState` のアイコンの円
- `AttachmentThumbnail` のタイル

いずれも「これまで薄すぎて形が見えていなかったものが見えるようになった」変更で、
配置や寸法は動いていない。

### 使う側でやること

- **`DefaultTheme` を使っているアプリ**: 依存を上げた時点でライトの見た目が変わる。
  スナップショットを持っているなら差分が出るので、撮り直す前に 1 度目で見ること
- **自前の `ColorPalette` を持っているアプリ**: 影響なし。ただし同じ欠陥を自前パレットで
  やっていないかは見ておくとよい。地と面の比が 1.10 を下回っていたら、輪郭が影頼りになっている
- `SurfaceStepContrastTests` が面の段差の下限（1.10）を見ている。パレットを差し替えるときの
  目安に使える

### 見送り

- ダークのパレットは触っていない。地と面が 1.209、面と `surfaceVariant` が 1.424 あり、
  実機で撮って確認しても十分に分離している

## [2.3.0] - 2026-08-01

行のレイアウトとテキストの寸法を、画面側で手当てしなくても揃うようにした回。
今まで「アイコンの位置が行ごとに数 pt ずれる」「iPad で本文が横に伸びきる」
「文字サイズを上げても本文が拡大しない」は、いずれも呼び出し側で直しても再発する
性質の欠陥だった。原因がライブラリ側にあるので、ライブラリ側で塞ぐ。

### 追加

- **`SectionRowLabel`** — `SectionRow` の先頭に置く、アイコン列付きのラベル。
  アイコンの無い行でも列のぶんを空けるため、アイコンのある行と無い行でラベルの
  左端が縦に揃う。副題も持てる（`SectionRowLabel("メール", subtitle: "user@example.com")`）。
  列の幅は `IconSizeScale.lg`（32pt）で、`LinkCard` の先頭 `IconBadge(.small)` と同じ。
  行の余白と合わせるとラベルの左端が 56pt になり、設定アプリの行と同じ位置に来る。
- **`.readableWidth()`** — 本文の幅を読みやすい上限で頭打ちにして中央に置く。
  SwiftUI には UIKit の `readableContentGuide` に相当する API が無く、画面ごとに
  `.frame(maxWidth:)` を手で書くと値がばらつくため、決め方をここに 1 本化した。
  上限は Dynamic Type 既定で 672pt、文字サイズに応じて 560〜896pt のあいだで伸縮する
  （`readableContentGuide` の実測に合わせた）。効くのは横も縦も `.regular` のときだけで、
  iPhone 縦や iPad の細い分割では何もしない。そこで頭打ちにしても余白が増えるだけになる。
- `Typography.relativeTextStyle` — 役割ごとの Dynamic Type の追随先。
  iOS のテキストスタイルは大きいものほど拡大率が小さいため、大きい役割を大きい
  スタイルに相対させることで、文字を最大まで上げても display だけが画面を埋めない。

### 変更

- **`SectionRow` が行の骨格を持つようになった。** 今までは HStack に余白を付けるだけで、
  行の最小高も先頭アイコン列の幅も規定していなかった。アイコンの寸法（`IconSizeScale`）と
  テキストの寸法（`TypographyScale`）が別々に決まるため、記号の字幅の違いがそのまま
  ラベルの左端のずれになっていた。
  - 行の最小高が最小タップ領域（44pt）を下回らなくなった。本文 1 行だけの行は
    これまで約 41pt で、Apple の下限を割っていた
  - 先頭アイコン列の幅が固定された。`SectionRow { Label(...) }` と書いた**既存のコードも
    そのまま**列が効く（行が自分の中身に `LabelStyle` を配る形にしたため、API は変えていない）
  - 骨格は `@ScaledMetric` で Dynamic Type に追随する。列も行高も文字と一緒に伸びる
- **`.typography(_:)` が Dynamic Type に追随するようになった。** 今までは解決したサイズを
  そのまま `Font.system(size:)` に渡していたため、アクセシビリティ設定で文字サイズを
  上げても本文が拡大しなかった。倍率は `.system` と `.named`（ブランド書体）に共通で掛かる。
  行間・字間も拡大後のサイズから引き直すので、文字だけ大きくなって行が詰まることはない。
- `SectionNavigationLabel` が内部で `SectionRowLabel` を使うようになった。
  `systemImage` を省いた場合もアイコン列を空けるため、同じセクション内の
  アイコン付きの行と左端が揃う。`subtitle:` を受け取れるようになった。

### 見送り

- **ガラス（`glassSurface` / `frostedSurface` / `.glass` ボタン）の `if #available(iOS 26.0)`
  分岐はそのまま残す。** 下限が iOS 17 のまま依存しているアプリがあり、分岐を外すと壊れる。
  下限が 26 のアプリでは実行時に必ずガラス経路を通るので、現状のままで正しい。

### 使う側でやること

- **必須の対応は無い。** 既存の呼び出しはすべてそのまま通る
- `SectionRow` を使っている画面は行の高さが最大 3pt ほど伸びる。密度を詰めていた
  レイアウトは一度見ておくとよい
- アイコンのある行と無い行を同じセクションに混ぜている画面は、
  `Text(...)` / `Label(...)` を `SectionRowLabel(...)` に置き換えると左端が揃う
- 文字サイズを上げたときのレイアウトは、これまで固定サイズだったぶん未検証になっている。
  `.dynamicTypeSize(.accessibility3)` あたりで一度見ておくとよい
- iPad 対応の画面では、本文を包む階層に `.readableWidth()` を付けると
  1 行が長くなりすぎない

## [2.2.0] - 2026-07-27

### 追加
- `imagePicker` に `resize: ImageResizeRule?`（`.square(N)` = center-crop した正方形 /
  `.longestEdge(N)` = 長辺を N に収める）を追加。処理順は リサイズ → JPEG 化 →
  （`maxSize` があれば）品質。表示に使わない画素を運ぶのが一番無駄なので、品質より先に寸法を落とす。
  既定 nil で従来挙動を維持（非破壊）。
- `UIImage.resized(by:)` を公開。描き直す前に EXIF の向きを解決するため、戻り値は必ず `.up` /
  scale 1 になる。縦で撮った写真が横になることがない。どちらの規則も元より大きくはしない。

### 変更
- **写真ライブラリの選択を `PHPickerViewController` へ置き換え**（`imagePicker` のみ）。
  選択がアプリの外で完結しライブラリ全体に触れないため、写真の権限が要らなくなった。
  Info.plist の `NSPhotoLibraryUsageDescription` と、ライブラリ側の権限リクエスト・
  拒否時アラートを削除。カメラは撮影の許可が正当に要るので `UIImagePickerController` と
  `NSCameraUsageDescription` のまま。
  なお `videoPicker` は従来どおり `UIImagePickerController` を使うため、動画を扱うアプリでは
  引き続き `NSPhotoLibraryUsageDescription` が必要。

## [1.7.0] - 2026-06-14

### 追加
- `imagePicker` に `source: ImagePickerSource`（`.automatic` / `.camera` / `.photoLibrary`）を追加。
  `.camera` 指定で chooser を出さずカメラを直接提示できる（カメラ専用ボタン用）。既定 `.automatic`
  で従来挙動を維持（非破壊）。

## [1.6.0] - 2026-06-14

### 追加
- **添付 UI atom**: `AttachmentThumbnail`（画像/ファイルのサムネ + ✕ 削除）と
  `AttachmentStrip`（横スクロールの純レイアウトコンテナ、ViewBuilder のみ受ける logic-less）。
  ドメイン型・IO・state を持たず、削除は callback。Catalog に Attachment を追加。

## [1.3.2] - 2026-06-07

### 追加
- **StatusIndicatorコンポーネント** - 非同期の作業状態を 1 グリフで表すインジケーター
  - `StatusKind` (pending / running / success / failure / canceled) をセマンティックカラーへ写像
  - `StatusKind.color(in:)` で周辺要素（バッジ等）の色をインジケーターと揃えられる
  - 実行中はシステム `ProgressView`、各状態に accessibilityLabel 自動付与
- **StepIndicatorコンポーネント** - N ステップの現在位置を表すドット列
  - 現在 = primary、通過 = 薄い primary、未来 = outlineVariant
  - `currentIndex: nil` = 全ステップ終了。アクセシビリティラベル「ステップ N / M」を自動生成
- **TimelineRowコンポーネント** - 時系列フィード（アクティビティログ）の 1 行
  - 左にマーカー + 縦コネクタ線、右に任意コンテンツ。`VStack(spacing: 0)` で連続タイムライン
  - マーカーは `StatusIndicator`（status: 指定）または任意ビュー（marker: クロージャ）
- **LinkCardコンポーネント** - URL 参照（出典・関連リンク）のカード
  - タイトル + ドメイン + 任意アクセサリ（Chip 等）。action 付きはタップ可能
  - メタデータ取得は呼び出し側の責務（LinkPresentation 非依存）
- **EmptyStateコンポーネント** - 空リスト・空検索結果の明示ステート
  - アイコン + 見出し + 任意の説明文。accessibilityElement(children: .combine)
- カタログアプリに上記 5 コンポーネントのセクションを追加

## [1.0.24] - 2026-04-14

### 追加
- **Sectionコンポーネント群** - 設定画面・ハブ画面用の surface カード (ADR-014)
  - `SectionCard(_ header:, footer:)` - 小さな uppercase ヘッダー + 角丸 surface + footer 説明文
  - `SectionRow` - 統一 padding の HStack 行。`contentShape(Rectangle())` で余白部分もタップ可能
  - `SectionRowDivider` - `outlineVariant` カラーの 0.5pt ヘアライン区切り
  - `SectionNavigationLabel` - chevron 付き NavigationLink 用ラベル
  - 4 コンポーネントとも DS トークン（spacing / radius / typography / colorPalette）のみで構成
  - iOS 26 Liquid Glass 相当の surface material 表現に対応

### 変更
- **SectionCard** - 既存の `SectionCard(title:, elevation:)` 初期化子は互換維持のため残存。
  新規利用は `SectionCard(_ header:, footer:)` の Surface Section スタイルを推奨
- `Sources/DesignSystem/Layout/Patterns/SectionCard.swift` を `Sources/DesignSystem/Components/Section/SectionCard.swift` に統合移動（タイプ重複回避）

## [1.0.22] - 2026-01-06

### 追加
- **IconBadgeコンポーネント** - 円形背景にSF Symbolアイコンを表示するバッジ (#36)
  - 4つのサイズ: small (24pt), medium (32pt), large (48pt), extraLarge (64pt)
  - カスタマイズ可能な前景色と背景色
  - ステータス表示、機能ハイライト、カテゴリアイコンに最適
  - カタログアプリに「IconBadge」セクション追加

- **ProgressBarコンポーネント** - 水平プログレスインジケータ (#36)
  - スプリングアニメーション付きの進捗表示
  - カスタマイズ可能な高さと色
  - 不確定状態（indeterminate）のサポート
  - ローディング進捗、完了状況、目標トラッキングに最適
  - カタログアプリに「ProgressBar」セクション追加

- **StatDisplayコンポーネント** - メトリクス表示コンポーネント (#36)
  - ラベル、値、オプションの単位を表示
  - 縦・横レイアウトの選択
  - トレンドインジケータ（上/下矢印）のサポート
  - ダッシュボード統計、メトリクスカード、KPI表示に最適
  - カタログアプリに「StatDisplay」セクション追加

### 変更
- **カタログアプリの大規模リファクタリング**
  - 共通コンポーネントの導入: CatalogPageContainer, CatalogOverview, VariantShowcase, CodeExample
  - 22のカタログ詳細ビューを統一された構造に移行
  - ナビゲーション構造の統一: Foundation, Components, Patternsが同じリストビューパターンを使用
  - CatalogItemRowContentによる行表示の共通化

- **デザイントークンへの完全移行**
  - ハードコードされたスペーシング値（1, 2, 4, 6）をspacing tokens（xxs, xs, sm, md）に置換
  - ハードコードされた角丸値（4, 6, 8, 12）をradius tokens（xs, sm, md, lg）に置換
  - ハードコードされた色（Color.green, Color.red等）をsemantic colors（colors.success, colors.error等）に置換
  - ハードコードされたフォントをtypography tokensに置換
  - ハードコードされたアニメーションをmotion tokensに置換

- **Cardコンポーネントの簡素化** (#36)
  - @ViewBuilderを使用したシンプルな実装に変更
  - 冗長な内部状態管理を削除

### 削除
- **CatalogItem.swift** - 冗長な中間レイヤーを削除
- **PatternType.swift** - 未使用のため削除
- `CatalogCategory.items`プロパティ - CatalogCategoryの直接プロパティに統合
- `CatalogRouter.destination(for:item:)`の`item`パラメータ - 未使用のため削除

## [1.0.21] - 2025-12-21

### 追加
- **VideoPickerコンポーネント** - カメラまたは動画ライブラリから動画を選択するモディファイア (#34)
  - `.videoPicker()` ViewModifierによるシンプルなAPI
  - カメラ撮影と動画ライブラリ選択の統合UI
  - 包括的な権限管理（カメラ、マイク、フォトライブラリ）
  - 高画質撮影設定（1920x1080、typeHigh）
  - iPadでのフルスクリーンカメラ表示対応
  - ファイルサイズ制限（`maxSize: ByteSize`）
  - 録画時間制限（`maxDuration: TimeInterval`）
  - エラーハンドリング（`onError`コールバック）
  - カタログアプリに「VideoPicker」セクション追加

- **VideoPlayerViewコンポーネント** - 動画再生プレイヤー (#34)
  - `Data`または`URL`から動画を再生
  - AVPlayerViewControllerによるネイティブフルスクリーン対応
  - メタデータ表示（長さ、解像度、ファイルサイズ）
  - アクションChipによる操作UI（再生/一時停止、共有、保存）
  - カメラロールへの保存機能（権限管理、Snackbarフィードバック）
  - オーディオセッション自動設定
  - 一時ファイルの自動クリーンアップ
  - カタログアプリに「VideoPlayer」セクション追加

- **ByteSize型** - ファイルサイズを扱う型安全なユーティリティ (#34)
  - `Int.kb`, `Int.mb`, `Int.gb` 拡張による直感的なサイズ指定
  - 人間可読なフォーマット出力（`formatted`プロパティ）
  - 比較演算子サポート

- **Action Chip** - タップアクション付きChipバリアント (#34)
  - `Chip(label, systemImage:, action:)` イニシャライザ
  - 削除可能Chipとの明確な区別

### 変更
- **ImagePickerのAPI改善** (#34)
  - `maxSizeInBytes: Int`を`maxSize: ByteSize`に変更（破壊的変更）
  - より直感的なファイルサイズ指定（例: `50.mb`）

### 修正
- **iPadでの動画撮影品質改善** (#34)
  - `videoQuality = .typeHigh`と`videoExportPreset = AVAssetExportPreset1920x1080`を設定
  - フルスクリーンカメラ表示に変更（シート表示から変更）

- **動画保存時のクラッシュ修正** (#34)
  - MainActorアイソレーション問題を解決（`@Sendable`クロージャ使用）
  - ファイル存在チェックを追加
  - 保存中の一時ファイル削除を防止

## [1.0.20] - 2025-11-17

### 追加
- **IconPicker、EmojiPicker、ColorPickerコンポーネント** - 選択UI用の3種類のピッカーモディファイア (#32)
  - **IconPicker (SF Symbols専用)**
    - `.iconPicker()` ViewModifierによるシンプルなAPI
    - `Image(systemName:)`による正しいSF Symbols表示
    - カテゴリベースの組織化（IconCategory/IconItem）
    - ハーフモーダル表示（`.medium`, `.large`デテント）
    - 検索機能とカテゴリフィルタリング
    - 選択状態の視覚的フィードバック
  - **EmojiPicker (絵文字専用)**
    - `.emojiPicker()` ViewModifierによるシンプルなAPI
    - 大きめのフォントサイズ（32pt）で絵文字を表示
    - カテゴリベースの組織化（EmojiCategory/EmojiItem）
    - ハーフモーダル表示（`.medium`, `.large`デテント）
    - 検索機能とカテゴリフィルタリング
    - 顔・感情、動物・自然、食べ物、活動などのカテゴリ
  - **ColorPicker (プリセットカラー)**
    - `.colorPicker()` ViewModifierによるシンプルなAPI
    - プリセットカラーシステム（ColorPreset）
    - `.tagFriendly`: タグやカテゴリに適した10色
    - `.allPrimitives`: プリミティブカラー全体
    - ハーフモーダル表示（`.medium`, `.large`デテント）
    - 検索機能とカテゴリフィルタリング
  - 全ピッカー共通の特徴
    - ViewModifierパターンによる一貫したAPI
    - ハーフモーダルシート（`.presentationDetents`使用）
    - カテゴリ別タブナビゲーション
    - 検索フィールドによるフィルタリング
    - 選択/キャンセルボタン配置
    - デザインシステムトークンとの完全統合
  - カタログアプリに3つの新しいセクション追加
    - ColorPickerCatalogView: カラーピッカーのデモと使用例
    - EmojiPickerCatalogView: 絵文字ピッカーのデモと使用例
    - IconPickerCatalogView: アイコンピッカーのデモと使用例

## [1.0.19] - 2025-11-17

### 追加
- **ImagePickerコンポーネント** - カメラと写真ライブラリから画像を選択するモディファイア (#28)
  - `.imagePicker()` ViewModifierによるシンプルなAPI
  - カメラ撮影と写真ライブラリ選択の統合UI
  - 包括的な権限管理（カメラとフォトライブラリ）
  - `.addOnly`権限レベルによる最小権限アクセス
  - カメラ利用可能性チェック（iPad等非搭載デバイス対応）
  - 画像圧縮戦略（`maxSizeInBytes`パラメータ）
    - 再帰的品質調整による目標サイズへの最適化
    - 既に上限以下の場合は圧縮をスキップ
  - エラーハンドリング（`onCompressionError`コールバック）
  - `.restricted`状態の明示的処理（MDM/ペアレンタルコントロール）
  - JPEG形式での画像データ返却
  - カタログアプリに「ImagePicker」セクション追加

- **Snackbarコンポーネント** - Material Design準拠の一時的通知UI (#26)
  - 画面下部から表示される一時的な通知UI
  - `SnackbarState`による`@Observable`ベースの状態管理
  - 自動消滅機能（デフォルト5秒、カスタマイズ可能）
  - 最大2つのアクションボタンサポート（プライマリ、セカンダリ）
  - スプリングアニメーション付き表示/非表示トランジション
  - アクセシビリティサポート（accessibilityLabel対応）
  - デザインシステムトークンとの完全統合（カラー、スペーシング、角丸）
  - カタログアプリに「Snackbar」セクション追加

## [1.0.18] - 2025-11-16

### 追加
- **Snackbarコンポーネント** - Material Design準拠の一時的通知UI (#26)
  - 画面下部から表示される一時的な通知UI
  - `SnackbarState`による`@Observable`ベースの状態管理
  - 自動消滅機能（デフォルト5秒、カスタマイズ可能）
  - 最大2つのアクションボタンサポート（プライマリ、セカンダリ）
  - スプリングアニメーション付き表示/非表示トランジション
  - アクセシビリティサポート（accessibilityLabel対応）
  - デザインシステムトークンとの完全統合（カラー、スペーシング、角丸）
  - カタログアプリに「Snackbar」セクション追加

## [1.0.17] - 2025-11-09

### 追加
- **タイポグラフィトークンシステムの実装** (#23)
  - `Typography.Font.Design`プロトコルによる柔軟なフォント管理
  - 日本語フォント切り替え機能
    - `JapaneseRoundedFontDesign`: SF Rounded（丸ゴシック）スタイル
    - `JapaneseSerifFontDesign`: 游明朝体（セリフ）スタイル
  - `FontDesignProvider`による動的フォント切り替え
  - カタログアプリに「タイポグラフィ」セクション追加
  - フォントスタイルプレビューとフォントデザイン切り替えUI実装

- **iPad Split View対応の実装** (#24)
  - 包括的なリファクタリングによる適応的レイアウト
  - `AdaptiveLayoutProvider`による画面サイズ認識
  - `LayoutContext`による動的レイアウト調整
  - カタログアプリの全ビューをiPad Split View対応に改善
  - Compact/Regular幅に応じたスペーシングとレイアウトの最適化

## [1.0.16] - 2025-11-09

### 追加
- **Motionシステム** - 統一されたアニメーションタイミングシステム (#20)
  - 10種類の最適化されたアニメーションタイミング
  - マイクロインタラクション: `quick` (70ms), `tap` (110ms)
  - 状態変化: `toggle`, `fadeIn`, `fadeOut` (150ms)
  - トランジション: `slide` (240ms), `slow` (300ms), `slower` (375ms)
  - スプリング: `spring`, `bounce`
  - Material Design 3、IBM Carbon、Apple HIGの業界標準に準拠
  - `.animate()` modifierによる簡単適用
  - 自動Reduce Motion対応（WCAG 2.1 SC 2.3.3準拠）
  - Sendable準拠で並行処理安全

- **Motionカタログビュー** - 包括的なアニメーションカタログ (#20)
  - 概要セクション: システム説明と主な機能
  - インタラクティブデモ: 4カテゴリ別の体験可能なアニメーション
  - 仕様表: 全10モーションの詳細スペック
  - 使用例: 3パターンのコード例
  - アクセシビリティ説明: Reduce Motion自動対応
  - ベストプラクティス: 推奨パターンとアンチパターン
  - MotionDemoCard: AspectGridパターンでレスポンシブデザイン

### 変更
- **カタログUIの改善** (#21)
  - セクション間スペーシングを24pt → 32ptに増加（2025年デザインシステムベストプラクティス準拠）
  - カード風セクションデザインの導入（微妙なエレベーション効果）
  - フルブリードセクション（画面端まで）には角丸なし（iOS標準パターン）
  - 情報セクションには角丸あり（浮いているカード風）
  - Material Design 3、Fluent 2、Carbon Design Systemの2025年ベストプラクティスを調査・適用

- **既存コンポーネントのMotionシステム移行** (#20)
  - Button styles (Primary, Secondary, Tertiary) → Motionトークン使用
  - Chip styles (Filled, Outlined, LiquidGlass) → Motionトークン使用
  - ThemeGalleryView → Motionトークン使用

- **カスタムテーマのダークモード対応** (#21)
  - `SimpleBlueTheme`と`SimpleRedTheme`に完全なダークモード対応を追加
  - `ThemeMode`の全ケース（`.system`, `.light`, `.dark`）を適切に処理
  - ダークモードでは明るい色調に調整してコントラストを確保

### 修正
- **GitHub ActionsのXcode環境更新** (#19)
  - macOS 15 → macOS 26 (arm64)
  - Xcode 16.1 → Xcode 26.0.1
  - iOS 26 SDKサポート（`.glassEffect()` API使用のため）
  - DocCデプロイメントのコンパイルエラーを解消

### ドキュメント
- **カスタムテーマドキュメントの大幅改善** (#21)
  - `SimpleBlueTheme`と`SimpleRedTheme`に詳細なDocCコメント追加
  - README.mdの「カスタムテーマの作成」セクション刷新
    - ステップ1: ColorPaletteの実装（全27色の完全な例）
    - ステップ2: Themeプロトコルの実装
    - ステップ3: ThemeProviderへの登録（3パターン）
    - ステップ4: テーマの切り替え実装例
  - エントリーポイントへのドキュメント追加

## [1.0.15] - 2025-11-09

### 追加
- **Chipコンポーネント** - Material Design 3とLiquid Glassデザイン言語に準拠 (#15)
  - プロトコルベースのChipStyleシステム (ButtonStyleと同様)
  - サイズバリアント: Small (24pt), Medium (32pt)
  - 4つの初期化パターン: 静的、アイコン付き、削除可能、選択可能
  - インタラクティブ状態: pressed, selected
  - 完全なアクセシビリティサポート
  - 3つのスタイルバリアント:
    - **Filled**: 10-20%不透明度背景（ステータス/カテゴリラベル用）
    - **Outlined**: 1.5ptボーダー（フィルターとセカンダリカテゴリ用）
    - **Liquid Glass**: iOS 26+ネイティブ `.glassEffect()` API（インタラクティブサポート付き）
  - Swift 6並行性対応（全スタイルが`Sendable`に準拠、`@MainActor`メソッド）
  - トークンシステムとの統合（3層トークンアーキテクチャを活用）

- **AspectGridレイアウトパターン** - アスペクト比固定グリッドレイアウト (#16)
  - **GridSpacingトークン**: xs, sm, md, lg, xlの5段階の間隔設定
  - **適応サイジング**: 画面サイズに応じた自動調整 (minItemWidth, maxItemWidth)
  - **一般的なユースケース対応**: 商品一覧、写真ギャラリー、動画サムネイル
  - **サポートされるアスペクト比**:
    - 1:1 - 商品サムネイル、プロフィール画像、アイコン
    - 3:4 - 写真、ポートレート
    - 16:9 - 動画サムネイル、ワイドコンテンツ
  - LazyVGridベースの効率的なレンダリング
  - GridItem.adaptiveによる自動カラム調整
  - 完全なドキュメントコメントとコード例

- **カスタムテーマカテゴリ** - テーマ分類の拡張 (#17)
  - 新しい`.custom`カテゴリを追加
    - 名前: "カスタム"
    - 説明: "アプリ固有のカスタムテーマ"
    - アイコン: `wand.and.stars` ✨
  - テーマギャラリーでビルトインとカスタムを明確に区別
  - サンプルカスタムテーマの実装例（SimpleBlueTheme, SimpleRedTheme）

### 修正
- **テーマ動的切り替えの改善** (#17)
  - `ThemeEnvironmentView`のリアクティブ更新を修正
    - 問題: カラーパレットが静的に評価され、テーマ切り替え時に更新されなかった
    - 解決: `resolvedColorPalette`計算プロパティを追加し、`@Observable`の変更検知を活用
  - `ThemeGalleryView`の動的テーマ表示を改善
    - 問題: `ThemeRegistry.themesByCategory`（ビルトインのみ）を使用していた
    - 解決: `themeProvider.availableThemes`を使用してビルトイン + カスタムテーマを動的に表示
  - リアクティブシステム: `@Observable`と計算プロパティによる自動更新
  - 拡張性: カスタムテーマを簡単に追加できる設計
  - 初期テーマ指定: `initialTheme`パラメータで起動時のテーマを制御可能

## [1.0.14] - 2025-11-08

### 修正
- **PR自動作成の確実化（最終版）** - タイムスタンプコメント追加
  - CHANGELOG.mdの末尾に自動生成タイムスタンプコメントを追加
  - 比較リンクが既に正しい値でも必ず変更が発生
  - 確実にコミットが作成され、PR作成が成功する

## [1.0.13] - 2025-11-08

### 修正
- **リリースノート生成の改善** - インストール例のバージョンを動的に設定
  - ハードコードされた "1.0.0" を実際のリリースバージョンに変更
  - より正確で分かりやすいインストール手順を提供
- **PR自動作成の確実化** - CHANGELOG比較リンク更新ロジックを追加
  - リリース後に必ず比較リンクを最新バージョンに更新
  - 「未リリース」セクションが既に存在する場合でも確実にコミットが作成される
  - 次のリリース用ドラフトPRが確実に作成されるように改善

## [1.0.12] - 2025-11-08

### 修正
- **リリースワークフローの統合** - GitHub Release作成をauto-release-on-merge.ymlに統合
  - タグ作成と同時にGitHub Releaseが作成されるように改善
  - release.ymlワークフローを削除（機能を統合）
  - PAT（Personal Access Token）の設定が不要に
  - すべてがGITHUB_TOKENで完結する完全自動化を実現

### ドキュメント
- **RELEASE_PROCESS.mdを大幅に簡素化** - 本質的な情報のみに絞り込み
  - 冗長なセクションを削除
  - リリース手順を6ステップに簡素化
  - トラブルシューティングを必要最小限に整理

## [1.0.11] - 2025-11-08

### 変更
- **リリースワークフローの完全改訂** - よりシンプルで直感的なフローに変更
  - リリースブランチ（`release/vX.Y.Z`）からmainへのPRマージがリリースのトリガーに
  - タグは自動的に作成されるため、手動でのタグ作成が不要に
  - 次のリリースブランチとドラフトPRも自動作成
  - ワークフロー: `auto-release-on-merge.yml`を新規追加、`prepare-next-release.yml`を削除

### ドキュメント
- **RELEASE_PROCESS.mdを新しいワークフローに完全対応**
  - 新しい開発フローの全体像を追加
  - 詳細な手順を6ステップに整理
  - 自動化の仕組みセクションを刷新（`auto-release-on-merge.yml`の詳細な説明）
  - トラブルシューティングを新しいワークフローに対応

## [1.0.10] - 2025-11-08

### ドキュメント
- **リリースプロセスガイドの包括的な更新**
  - リリース思想とコンセプトを詳細に記載（ハイブリッドアプローチの理由、セマンティックバージョニング、Keep a Changelog）
  - 詳細な手順とワークフロー全体像を追加
  - CHANGELOG.mdの書き方のベストプラクティス（良い例/悪い例の比較）
  - 自動化の仕組みを技術的に解説（release.yml、prepare-next-release.yml）
  - トラブルシューティングガイドを充実
  - README.mdに開発者向け情報セクションを追加
  - 旧docsディレクトリを削除（内容は統合済み）

## [1.0.9] - 2025-11-08

### 追加
- **比較リンク自動更新** - prepare-next-releaseワークフローの改善
  - タグからバージョンを自動抽出
  - [未リリース]の比較リンクを最新バージョンに自動更新
  - リリース後の手動リンク更新作業が不要に

## [1.0.8] - 2025-11-08

### 修正
- **prepare-next-releaseワークフロー検証** - ドラフトPR自動作成の動作確認
  - 「未リリース」セクションが存在しない場合のPR作成フローを検証

## [1.0.7] - 2025-11-08

### 変更
- **リリースワークフローの改善** - GitHub Releaseに定型文とメタ情報を追加
  - リリースタイトル、インストール方法、リンクを自動生成
  - より分かりやすいリリースノート形式に変更

### 修正
- **prepare-next-releaseワークフロー** - ドラフトPR自動作成を実装
  - タグプッシュトリガーに変更（release:publishedイベントは動作しないため）
  - ドラフトPRの自動作成まで完全自動化

## [1.0.6] - 2025-11-08

### 追加
- ドキュメントの改善とリリースフロー検証

## [1.0.5] - 2025-11-08

### 追加
- **自動化ワークフロー** - リリース後の準備を自動化
  - `.github/workflows/prepare-next-release.yml` を追加
  - GitHub Release公開後に自動的に次のリリース準備PRをドラフト作成
  - CHANGELOG.mdの「未リリース」セクションを自動挿入
  - Keep a Changelogのベストプラクティスに基づく実装

## [1.0.4] - 2025-11-08

### 変更
- **リリースプロセスの改善** - ハイブリッドアプローチを採用
  - CHANGELOG.mdは人間が手動で管理（Keep a Changelog形式を維持）
  - GitHub Releasesはタグから自動生成
  - ベストプラクティスに基づく正しい設計に変更

### 削除
- 誤った自動化ワークフロー `prepare-next-version.yml` を削除
- 不要なスクリプト `prepare_next_version.sh` を削除
- 古いドキュメント `RELEASE_AUTOMATION.md` を削除

### 追加
- 新しいリリースワークフロー `.github/workflows/release.yml`
  - タグプッシュ時にCHANGELOG.mdから該当バージョンを抽出
  - GitHub Releaseを自動作成
- 包括的なリリースプロセスガイド `docs/RELEASE_PROCESS.md`

## [1.0.3] - 2025-11-08

### ドキュメント
- README.md のインストール方法を `upToNextMajor` に変更し、セマンティックバージョニングのベストプラクティスに準拠

## [1.0.2] - 2025-11-08

### 追加
- **マルチテーマシステム** - 7種類のビルトインテーマを追加
  - Default - Material Design 3準拠のデフォルトテーマ
  - Ocean - 海の青をベースとした落ち着いたテーマ
  - Forest - 森の緑をベースとした自然なテーマ
  - Sunset - 夕焼けのオレンジをベースとした温かいテーマ
  - Purple Haze - 鮮やかな紫をベースとしたクリエイティブなテーマ
  - Monochrome - グレースケールのミニマルなテーマ
  - High Contrast - WCAG AAA準拠の高コントラストテーマ
- **テーマアーキテクチャ**
  - `Theme` protocol - Protocol指向設計による拡張性の高いテーマシステム
  - `ThemeMode` - システム追従/ライト固定/ダーク固定の3モード対応
  - `ThemeCategory` - テーマの論理的分類（Standard, Brand Personality, Accessibility）
  - `ThemeRegistry` - 全テーマの一元管理
  - 各テーマにLight/Darkパレット実装（計14パレット）
- **カタログアプリUI**
  - `ThemeGalleryView` - カテゴリ別テーマ一覧表示
  - `ThemeDetailView` - テーマ詳細とインタラクティブプレビュー
  - `ThemeCardView` - テーマ選択カード
  - `ThemeColorPreview` - 全27色のカラーパレット表示
  - `AppearanceModeSection` - 外観モード切り替えUI
- **DesignSystemCatalogApp** - Xcodeプロジェクトとしてのカタログアプリケーション

### 変更
- **ThemeProvider の完全リライト**（破壊的変更）
  - `@Observable` マクロに移行
  - 初期化パラメータの変更:
    - 旧: `ThemeProvider(colorScheme:lightPalette:darkPalette:)`
    - 新: `ThemeProvider(initialTheme:initialMode:additionalThemes:)`
  - Environment注入方法の変更:
    - 旧: `.environment(\.themeProvider, provider)`
    - 新: `.environment(provider)`
  - デフォルトモードを `.system` に変更（システム設定に追従）
- **ThemeModifier の改善**
  - `ThemeMode.system` のColorScheme解決ロジック実装
  - `@Environment(\.colorScheme)` と連携して適切なパレットを選択
- **DesignSystemCatalogView の改善**
  - 冗長なヘッダーセクションを削除
  - ナビゲーションタイトルを「デザインシステムカタログ」に変更
  - 情報セクションにリポジトリとドキュメントへのリンク追加
  - バージョン・デザインシステム説明を削除（メンテナンス負荷軽減）

### 修正
- **カタログビューのハードコード色をテーマシステムに統一**
  - PatternsCatalogView/ComponentsCatalogView のヘッダーアイコン色を `colorPalette.primary` に統一
  - FeatureRow コンポーネントをテーマ対応（`color` パラメータを削除）
  - RadiusDemoView/SpacingDemoView の視覚デモをテーマカラーに対応
  - ButtonCatalogView の説明文と背景色をColorPaletteトークンに統一
  - ColorSwatchView の `.primary`/`.secondary`/`.tertiary` を `colorPalette` トークンに統一
  - すべてのカタログビューでSwiftUIネイティブセマンティックカラーを排除し、Material Design 3準拠に統一

### 削除
- `ThemeProviderKey` - @Observableに移行したため不要
- カスタムEnvironmentKeyによるThemeProvider注入パターン

### ドキュメント
- README.md にマルチテーマシステムの包括的なドキュメント追加
  - 7テーマの特徴と用途を説明する表
  - テーマ切り替えとモード選択の使用例
  - カスタムテーマ作成ガイド
- 全テーマファイルに詳細なドキュメントコメント追加
- ThemeProtocol/ThemeRegistry/ThemeMode/ThemeCategory に実践的なコード例追加

## [1.0.1] - 2025-01-08

### 修正
- Swift 6のStrictConcurrency機能がデフォルトで有効になっているため、明示的な設定を削除
- Package.swiftの不要なswiftSettings設定を削除してビルドエラーを解消

## [1.0.0] - 2025-01-08

### 追加
- 3層デザイントークンシステム（Primitive, Semantic, Component）
- プロトコルベースのカラーパレット（`ColorPalette`）
  - Light/Darkテーマのデフォルト実装
  - Primary, Secondary, Tertiary カラースキーム
  - Semantic state colors（Error, Warning, Success, Info）
- スペーシングスケール（`SpacingScale`）
  - Tシャツサイズ命名規則（xs, sm, md, lg, xl, etc.）
  - none (0pt) から xxxxl (96pt) までの11段階
- 角丸スケール（`RadiusScale`）
  - xs (2pt) から xxl (24pt) までの7段階
  - full（完全な円形）サポート
- タイポグラフィシステム（`Typography`）
  - Display, Headline, Title, Body, Label の5カテゴリ
  - 14種類の定義済みテキストスタイル
  - `.typography()` モディファイアによる簡単適用
- ThemeProvider による動的テーマ切り替え
  - Light/Dark/カスタムテーマ対応
  - `@Observable` によるリアクティブな更新
  - システムテーマ追従機能
- ボタンコンポーネント
  - PrimaryButtonStyle - 主要アクション用
  - SecondaryButtonStyle - 補助アクション用
  - TertiaryButtonStyle - 控えめなアクション用
  - TextButtonStyle - テキストのみのボタン
  - ButtonSize（Large, Medium, Small）によるサイズ統一
- カードコンポーネント
  - Card - 汎用カードコンテナ
  - Elevation レベル（Level0-3）による影の管理
- IconButton - アイコンベースのボタン
- FloatingActionButton (FAB) - 主要アクションボタン
- DSTextField - デザインシステム統合テキストフィールド
  - エラー状態、フォーカス状態対応
  - プレースホルダー、キーボードタイプ設定
  - セキュアテキスト入力サポート
- レイアウトパターン
  - SectionCard - タイトル付きカードセクション
- View Modifiers
  - `.theme(_:)` - ThemeProvider 適用
  - `.buttonSize(_:)` - ボタンサイズ指定
  - `.typography(_:)` - タイポグラフィ適用
- カスタムテーマ作成サポート
  - 独自のカラーパレット実装
  - カスタムスペーシング・角丸スケール
- HEX文字列からの Color 初期化（`Color(hex:)`）
  - 3桁、6桁、8桁（アルファ付き）対応
- 完全なドキュメントコメント
  - 全パブリックAPIに実践的なコード例
  - ユーザー視点の使用ガイド

### ドキュメント
- 包括的な README.md
  - クイックスタートガイド
  - デザイントークンの使用例
  - カスタムテーマ作成例
  - ログイン画面・設定画面の実装例
- API リファレンス
- アーキテクチャガイド（3層トークンシステム）
- DocC 対応
  - GitHub Pages での自動ドキュメント公開

[未リリース]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.22...HEAD
[1.0.22]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.21...v1.0.22
[1.0.21]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.20...v1.0.21
[1.0.20]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.19...v1.0.20
[1.0.19]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.18...v1.0.19
[1.0.18]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.17...v1.0.18
[1.0.17]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.16...v1.0.17
[1.0.16]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.15...v1.0.16
[1.0.15]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.14...v1.0.15
[1.0.14]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.13...v1.0.14
[1.0.13]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.12...v1.0.13
[1.0.12]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.11...v1.0.12
[1.0.11]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.10...v1.0.11
[1.0.10]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.9...v1.0.10
[1.0.9]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.8...v1.0.9
[1.0.8]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/no-problem-dev/swift-design-system/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/no-problem-dev/swift-design-system/releases/tag/v1.0.0

<!-- Auto-generated on 2025-11-08T11:54:43Z by release workflow -->

<!-- Auto-generated on 2025-11-09T00:21:22Z by release workflow -->

<!-- Auto-generated on 2025-11-09T08:30:33Z by release workflow -->

<!-- Auto-generated on 2025-11-09T13:28:30Z by release workflow -->

<!-- Auto-generated on 2025-11-16T09:24:46Z by release workflow -->

<!-- Auto-generated on 2025-11-16T22:16:30Z by release workflow -->

<!-- Auto-generated on 2025-11-16T23:22:19Z by release workflow -->

<!-- Auto-generated on 2025-12-21T03:25:36Z by release workflow -->
