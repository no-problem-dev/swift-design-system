# AdaptiveGrid Implementation Strategy

## Executive Summary

グリッド、カルーセル、カード、リストレイアウトの中で、**AdaptiveGrid（適応グリッド）**が最も優先度が高く、次に実装すべきコンポーネントと決定。

**選定理由**:
- 最も基盤的なレイアウトコンポーネント
- ReadingMemoryアプリで既に使用されており、共通化の価値が高い
- 他のコンポーネント（Card、ListItem）を配置する基盤となる
- 主要デザインシステム（Material Design 3、Fluent 2、Ant Design）すべてで提供

## Design System Research Summary

### Material Design 3
**アプローチ**: Window Size Classes（compact, medium, expanded）

- **カラム**: 4/8/12列（画面サイズに応じて）
- **Gutter**: 16dp (360dp breakpoint), 24dp (600dp+ breakpoint)
- **マージン**: 可変（画面サイズに応じて調整）
- **思想**: ブレークポイントベースのレスポンシブデザイン
- **特徴**: Material 3では従来のグリッドからWindow Size Classへ移行

### Fluent 2 (Microsoft)
**アプローチ**: 12列グリッドシステム

- **カラム**: 12列（柔軟な分割が可能）
- **Gutter**: ベースユニットの倍数
- **Spacers**: タッチターゲット考慮（iOS 44x44pt, Android 48x48pt）
- **デザイントークン**: spacing, size tokensとの統合
- **特徴**: モジュラーグリッド（垂直・水平の両方）

### Apple SwiftUI
**アプローチ**: ネイティブAPI重視

- **LazyVGrid/LazyHGrid**: 遅延読み込みで最適化
- **GridItem**: `.flexible()`, `.fixed()`, `.adaptive()`の3モード
- **Grid (iOS 16+)**: 静的2次元レイアウト
- **特徴**: パフォーマンス最適化済み、カスタマイズは限定的

### Ant Design
**アプローチ**: 24列グリッドシステム（最も細かい）

- **カラム**: 24列（精密な制御が可能）
- **ブレークポイント**: 6段階（xs, sm, md, lg, xl, xxl）
- **Gutter**: (16 + 8n)px推奨、水平・垂直独立制御
- **特徴**: Flexboxベース、Bootstrap 4互換

### 共通パターン
1. **12または24の列システム**（除算しやすい）
2. **レスポンシブブレークポイント**（3-6段階）
3. **可変gutter**（画面サイズに応じて調整）
4. **Flexbox/Grid CSSベース**（Web）
5. **デザイントークンとの統合**

## Implementation Architecture

### Component Name: AdaptiveGrid

**選定理由**:
- Material Design 3の"adaptive layout"に合致
- SwiftUIの`GridItem.adaptive`と一貫性
- 最も汎用的で実用的
- ReadingMemoryの本棚ビューに直接適用可能

### File Structure

```
Sources/DesignSystem/
├── Components/
│   └── Grid/
│       ├── AdaptiveGrid.swift           // メイン実装
│       ├── FixedGrid.swift              // 固定カラム版（Phase 2）
│       ├── ResponsiveGrid.swift         // ブレークポイント版（Phase 3）
│       ├── GridSpacing.swift            // スペーシングトークン
│       └── GridAlignment.swift          // 配置オプション
│
└── Catalog/
    └── Components/
        └── GridCatalogView.swift        // デモとドキュメント
```

### API Design

#### Basic Usage
```swift
AdaptiveGrid(minItemWidth: 160, spacing: 16) {
    ForEach(items) { item in
        ItemView(item)
    }
}
```

#### With Design Tokens
```swift
AdaptiveGrid(minItemWidth: 160, spacing: .md) {
    ForEach(books) { book in
        BookCard(book)
    }
}
```

#### Advanced Configuration
```swift
AdaptiveGrid(
    minItemWidth: 160,
    maxItemWidth: 200,
    spacing: .md,
    alignment: .leading,
    pinnedViews: [.sectionHeaders]
) {
    Section("Fiction") {
        ForEach(fictionBooks) { book in
            BookCard(book)
        }
    }
    Section("Non-Fiction") {
        ForEach(nonFictionBooks) { book in
            BookCard(book)
        }
    }
}
```

### Core Implementation

```swift
import SwiftUI

/// Adaptive grid layout that automatically adjusts column count based on available width
///
/// AdaptiveGridは、利用可能な幅に基づいてカラム数を自動調整するグリッドレイアウトです。
/// Material Design 3のadaptive layoutとSwiftUIのLazyVGridを組み合わせた実装です。
///
/// ## 使用例
/// ```swift
/// AdaptiveGrid(minItemWidth: 160, spacing: .md) {
///     ForEach(books) { book in
///         BookCard(book)
///     }
/// }
/// ```
public struct AdaptiveGrid<Content: View>: View {
    @Environment(\.spacingScale) private var spacingScale
    
    private let minItemWidth: CGFloat
    private let maxItemWidth: CGFloat?
    private let spacing: GridSpacing
    private let alignment: HorizontalAlignment
    private let pinnedViews: PinnedScrollableViews
    private let content: () -> Content
    
    public init(
        minItemWidth: CGFloat,
        maxItemWidth: CGFloat? = nil,
        spacing: GridSpacing = .md,
        alignment: HorizontalAlignment = .center,
        pinnedViews: PinnedScrollableViews = [],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minItemWidth = minItemWidth
        self.maxItemWidth = maxItemWidth
        self.spacing = spacing
        self.alignment = alignment
        self.pinnedViews = pinnedViews
        self.content = content
    }
    
    public var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(minimum: minItemWidth, maximum: maxItemWidth ?? .infinity),
                    spacing: spacing.value(from: spacingScale)
                )
            ],
            alignment: alignment,
            spacing: spacing.value(from: spacingScale),
            pinnedViews: pinnedViews
        ) {
            content()
        }
    }
}
```

### GridSpacing Token

```swift
/// Grid spacing token that integrates with SpacingScale
public enum GridSpacing {
    case xxxs
    case xxs
    case xs
    case sm
    case md
    case lg
    case xl
    case xxl
    case xxxl
    case custom(CGFloat)
    
    func value(from scale: any SpacingScale) -> CGFloat {
        switch self {
        case .xxxs: return scale.xxxs
        case .xxs: return scale.xxs
        case .xs: return scale.xs
        case .sm: return scale.sm
        case .md: return scale.md
        case .lg: return scale.lg
        case .xl: return scale.xl
        case .xxl: return scale.xxl
        case .xxxl: return scale.xxxl
        case .custom(let value): return value
        }
    }
}
```

## Design Token Integration

### Spacing Recommendations

| Use Case | Spacing | Value | Description |
|----------|---------|-------|-------------|
| Dense Layout | `.xs` | 8pt | 密集したレイアウト、小さいカード |
| Compact | `.sm` | 12pt | コンパクトな表示 |
| Standard | `.md` | 16pt | 標準的なグリッド（デフォルト） |
| Comfortable | `.lg` | 24pt | ゆったりとしたレイアウト |
| Spacious | `.xl` | 32pt | 広々とした表示 |

### Minimum Item Width Guidelines

| Content Type | minItemWidth | Description |
|--------------|--------------|-------------|
| Small Cards | 120-140pt | アイコン+ラベル |
| Book Covers | 140-160pt | 本の表紙サイズ |
| Product Cards | 160-180pt | 商品カード |
| Photo Gallery | 180-200pt | 写真サムネイル |
| Wide Cards | 200-240pt | 詳細情報カード |

## ReadingMemory Integration

### Current Implementation (BookShelfGridView)
```swift
// Before: 固定2カラム
LazyVGrid(columns: [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
], spacing: 16) {
    ForEach(books) { book in
        BookCard(book)
    }
}
```

### After: AdaptiveGrid
```swift
// After: 画面幅に応じて自動調整
AdaptiveGrid(minItemWidth: 160, spacing: .md) {
    ForEach(books) { book in
        BookCard(book)
    }
}
```

**メリット**:
- iPhoneとiPadで最適なカラム数を自動選択
- デザイントークンとの統合
- 一貫したスペーシング
- 再利用可能

## Accessibility Considerations

### VoiceOver Support
- 各グリッドアイテムは適切にフォーカス可能
- LazyVGridのネイティブアクセシビリティを継承
- セクションヘッダーのアクセシビリティラベル

### Dynamic Type
- アイテムサイズはフォントサイズに応じて調整
- minItemWidthは基準値、実際は拡大される可能性

### Reduce Motion
- アニメーションなし（静的レイアウト）
- スクロールパフォーマンスの最適化

### Touch Targets
- 最小タッチターゲット: 44x44pt（iOS HIG）
- spacingで十分な間隔を確保

## Performance Optimization

### Lazy Loading
- `LazyVGrid`を使用して遅延読み込み
- 画面外のアイテムは生成しない
- メモリ効率の向上

### View Recycling
- SwiftUIのネイティブビューリサイクル
- 大量アイテムでもスムーズなスクロール

### Computation Caching
- GridItemの計算は一度だけ
- レイアウト変更時のみ再計算

## Edge Cases

### Empty State
```swift
if items.isEmpty {
    EmptyStateView()
} else {
    AdaptiveGrid(minItemWidth: 160) {
        ForEach(items) { item in
            ItemCard(item)
        }
    }
}
```

### Single Item
- 1アイテムでも正常に動作
- minItemWidthに基づいて配置

### Variable Heights
- SwiftUIが自動的に処理
- 各行の高さは最も高いアイテムに合わせる

### Device Rotation
- GeometryReaderで自動再計算
- カラム数が動的に調整される

## Future Extensions

### FixedGrid (Phase 2)
```swift
FixedGrid(columns: 2, spacing: .md) {
    ForEach(items) { item in
        ItemCard(item)
    }
}
```

### ResponsiveGrid (Phase 3)
```swift
ResponsiveGrid(spacing: .md) {
    ForEach(items) { item in
        ItemCard(item)
    }
}
.columns(compact: 2, regular: 3, expanded: 4)
```

### GridItem Variations
```swift
// Mixed sizes
MixedGrid {
    GridItem(.featured) {
        FeaturedCard()
    }
    GridItem(.standard) {
        StandardCard()
    }
}
```

## Implementation Phases

### Phase 1: Core Implementation (Priority: High)
**Duration**: 1-2 days

1. Create `AdaptiveGrid.swift` with basic implementation
2. Create `GridSpacing.swift` for token integration
3. Write comprehensive documentation
4. Add SwiftUI previews
5. Basic unit tests

**Deliverable**: Working AdaptiveGrid component

### Phase 2: Catalog & Documentation (Priority: High)
**Duration**: 1 day

1. Create `GridCatalogView.swift`
2. Showcase different spacing options
3. Demonstrate various use cases
4. Add best practices section
5. Integration examples

**Deliverable**: Complete catalog documentation

### Phase 3: ReadingMemory Integration (Priority: Medium)
**Duration**: 0.5 days

1. Replace `BookShelfGridView` implementation
2. Test on iPhone and iPad
3. Verify performance
4. Document migration pattern

**Deliverable**: Validated in production app

### Phase 4: Advanced Features (Priority: Low)
**Duration**: 2-3 days

1. Implement `FixedGrid`
2. Implement `ResponsiveGrid`
3. Add alignment options
4. Add pinned views support
5. Performance profiling

**Deliverable**: Complete grid system

## Success Metrics

1. **Functionality**: AdaptiveGrid works on iPhone and iPad
2. **Performance**: Smooth scrolling with 1000+ items
3. **Integration**: Successfully replaces BookShelfGridView
4. **Consistency**: Uses design system tokens
5. **Accessibility**: VoiceOver and Dynamic Type support
6. **Documentation**: Clear examples and best practices

## Technical Decisions

### Why LazyVGrid?
- **Performance**: Native lazy loading
- **Stability**: Apple-maintained, well-tested
- **Features**: Sections, pinned views, alignment
- **Accessibility**: Built-in support

### Why Not Custom Layout?
- **Complexity**: Requires significant development
- **Performance**: Hard to match native optimization
- **Maintenance**: More code to maintain
- **Features**: Would need to reimplement sections, etc.

### Hybrid Approach
- **Basic cases**: Use LazyVGrid wrapper (AdaptiveGrid)
- **Advanced cases**: Custom layout if needed (future)
- **Best of both**: Simple API, powerful features

## Next Steps

1. ✅ Review and approve this strategy
2. ⬜ Begin Phase 1 implementation (AdaptiveGrid core)
3. ⬜ Create GridCatalogView with examples
4. ⬜ Test with ReadingMemory use cases
5. ⬜ Document and release
