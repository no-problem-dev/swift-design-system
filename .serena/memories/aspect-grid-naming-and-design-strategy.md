# AspectGrid コンポーネント命名規則と設計方針

## 調査日
2025-11-09

## コンポーネント名: AspectGrid

### 命名根拠

**選定理由:**
1. **特徴の明確な表現**: アスペクト比固定グリッドという最大の特徴を名前で表現
2. **SwiftUI命名パターン準拠**: `[特徴]Grid` パターン（LazyVGrid, LazyHGrid と同様）
3. **簡潔性**: 2単語で発音可能
4. **混同リスク回避**: 他のデザインシステムで使用されていない独自の名前
5. **Swift規則準拠**: PascalCase準拠

**検討した代替案:**
- `AdaptiveGrid`: Material Design 3で「window size classへの適応」を意味するため不適切
- `RatioGrid`: 何の比率か不明確
- `FixedAspectGrid`: 明確だが3単語で冗長（Appleは通常2単語まで）
- `UniformGrid`: WPF/UWPと混同の可能性、何がuniformか不明確

## 主要デザインシステム調査結果

### Material Design 3
- **"Adaptive"の意味**: ウィンドウサイズクラス（compact/medium/expanded）への適応
- **"Responsive"の意味**: 柔軟なグリッドと画像による文脈対応
- M3では従来のresponsive gridではなく、window size classesを使用
- Breakpoint名: xs, sm, md, lg, xl

### Fluent 2
- Grid要素: columns, gutters, margins
- 12カラムフレームワークが一般的
- 専用Gridコンポーネントは提供せず、CSS GridとFlexboxの使用を推奨
- Grid種類: baseline, column, manuscript, modular

### Ant Design
- Breakpoint名: xs, sm, md, lg, xl, xxl（6段階）
- Responsive propertiesを持つ標準的なGrid/Col/Row
- Bootstrapのパターンに従う

### Chakra UI
- **SimpleGrid**: minChildWidth propで自動レスポンシブ対応
- CSS Grid の auto-fit と minmax() を内部で使用
- Breakpoint名: sm, md, lg, xl, 2xl
- アスペクト比の概念はなし

### SwiftUI
- LazyVGrid/LazyHGrid
- GridItem(.adaptive(minimum:maximum:))
- 変数名は通常 `columns` または `adaptiveColumns`

## API設計

### 最終API仕様

```swift
public struct AspectGrid<Content: View>: View {
    public init(
        minItemWidth: CGFloat,
        maxItemWidth: CGFloat,
        itemAspectRatio: CGFloat,
        spacing: GridSpacing = .md,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    )
}
```

### パラメータ設計根拠

#### minItemWidth / maxItemWidth
- **命名理由**: SwiftUIの `GridItem.adaptive(minimum:maximum:)` と整合性
- **item prefix**: グリッドアイテムの幅であることを明示
- **型**: CGFloat
- **役割**: アイテム幅の範囲を制御し、大画面でのオーバーサイズを防ぐ

#### itemAspectRatio
- **命名理由**: SwiftUIの `.aspectRatio()` modifier と整合性
- **必須パラメータ**: nilを許容しない（グリッドの不揃いを防ぐ）
- **型**: CGFloat
- **役割**: すべてのアイテムに統一されたアスペクト比を適用
- **実装**: コンポーネント内部で `.aspectRatio(itemAspectRatio, contentMode: .fit)` を適用

#### spacing
- **命名理由**: LazyVGridの `spacing` パラメータと同じ
- **型**: GridSpacing (カスタムenum)
- **デフォルト値**: .md (16pt)
- **役割**: グリッドアイテム間の固定ガター（間隔）

#### alignment
- **命名理由**: LazyVGridの `alignment` パラメータと同じ
- **型**: HorizontalAlignment
- **デフォルト値**: .center
- **役割**: グリッド内でのアイテムの水平配置

## 命名規則ベストプラクティス（2024年調査）

### 一般原則
1. **明確さ > 簡潔さ**: チーム全員が理解可能な名前
2. **機能ベース命名**: 値ではなく機能を表す名前
3. **発音可能**: 議論やコミュニケーションで使いやすい
4. **モジュラー**: 一貫性のある命名体系

### Swift/SwiftUI規則
- **PascalCase for types**: struct, class, enum, protocol
- **camelCase for properties**: 変数、メソッド
- **省略形を避ける**: btnSend ではなく sendButton
- **明確さ優先**: 目的が名前から明らか

### コンポーネント命名パターン
- CamelCase for components: ButtonPrimary, CardWithImage
- Modifier pattern: BaseComponent–Modifier
- Responsive variations: Button–SmallScreen
- Functional naming: 再ブランディングや変更に柔軟

## 関連型と構造

### GridSpacing (enum)
```swift
public enum GridSpacing: CGFloat, Sendable {
    case xs = 8   // 最小間隔（密集レイアウト）
    case sm = 12  // 小さい間隔（コンパクト）
    case md = 16  // 標準間隔（デフォルト）
    case lg = 20  // 大きい間隔（ゆとり）
    case xl = 24  // 最大間隔（大きなアイテム）
}
```

**設計根拠:**
- Material Design 3: 16-24dp gutters
- Fluent 2: 8-16px gutters
- Apple HIG: 8-20pt spacing
- 8pt grid systemに準拠

### ファイル構成
```
Sources/DesignSystem/
├── Components/Grid/
│   ├── AspectGrid.swift
│   └── AspectGridCatalogView.swift
├── Tokens/
│   └── GridSpacing.swift
```

## 使用例

### 基本的な使用
```swift
AspectGrid(
    minItemWidth: 160,
    maxItemWidth: 200,
    itemAspectRatio: 2/3,  // 書籍カバー比率
    spacing: .md
) {
    ForEach(books) { book in
        BookCoverView(book.cover)
        // .aspectRatio()不要！グリッド側が適用
    }
}
```

### カスタマイズ例
```swift
// 正方形アイコングリッド
AspectGrid(
    minItemWidth: 60,
    maxItemWidth: 80,
    itemAspectRatio: 1,  // 正方形
    spacing: .xs
) {
    ForEach(icons) { icon in
        IconView(icon)
    }
}

// 映画ポスターグリッド
AspectGrid(
    minItemWidth: 180,
    maxItemWidth: 240,
    itemAspectRatio: 3/4,  // ポスター比率
    spacing: .lg,
    alignment: .leading
) {
    ForEach(movies) { movie in
        PosterView(movie.poster)
    }
}
```

## 実装方針

### コアコンセプト
1. **アスペクト比の責務**: コンポーネントが担当（利用者は数値のみ指定）
2. **レイアウトの責務**: LazyVGridベースの効率的な実装
3. **トークン統合**: GridSpacingでデザインシステムとの一貫性
4. **SwiftUI慣習**: 既存APIとの整合性を最優先

### 技術実装
- LazyVGrid with GridItem.adaptive(minimum:maximum:)
- 内部で .aspectRatio(itemAspectRatio, contentMode: .fit) を適用
- Sendable準拠でスレッドセーフ
- @ViewBuilder for flexible content

## 混同リスク評価

### 低リスク
- ✅ Material Design "Adaptive" とは異なる概念
- ✅ Chakra UI "SimpleGrid" とは異なる機能
- ✅ WPF/UWP "UniformGrid" との混同なし
- ✅ SwiftUI LazyVGrid との明確な差別化

### 差別化ポイント
- LazyVGrid: アスペクト比を強制しない → AspectGrid: 必須
- Chakra SimpleGrid: minChildWidthのみ → AspectGrid: min/max両方
- 他システム: responsive breakpoints → AspectGrid: 固定アスペクト比

## まとめ

**AspectGrid** は:
- SwiftUI エコシステムに自然に統合される命名
- 機能を明確に表現（アスペクト比固定グリッド）
- 既存のデザインシステムとの混同を避ける
- Swift/SwiftUI命名規則に完全準拠
- 簡潔で発音可能、チーム内コミュニケーションに適している

この命名とAPI設計により、利用者は直感的に使用でき、メンテナンス性の高いデザインシステムを構築できる。
