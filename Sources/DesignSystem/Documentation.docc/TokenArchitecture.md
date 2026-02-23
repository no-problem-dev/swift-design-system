# Token Architecture

3層トークンシステムの設計思想と使い分け。

## Overview

DesignSystemは **Primitive → Semantic → Component** の3層トークンアーキテクチャを採用しています。
各層には明確な役割があり、適切な層のトークンを使うことで保守性と一貫性を担保します。

## Layer 1: Primitive Tokens

生の値（色のHEXコード、スペーシングのpt値など）を定義します。

> Warning: Primitive Tokensは内部実装の詳細です。View内で直接使用しないでください。

```swift
// ❌ 直接使用しない
PrimitiveColors.blue500
PrimitiveSpacing.space16
PrimitiveRadius.radius8
```

## Layer 2: Semantic Tokens

意味のあるトークンをプロトコルで定義します。
テーマやモードの切り替えに対応するため、**必ずこの層を使用してください**。

Environmentから取得して使用します:

```swift
// ✅ Semantic Tokensを使用
@Environment(\.colorPalette) var colors
@Environment(\.spacingScale) var spacing
@Environment(\.radiusScale) var radius
@Environment(\.motion) var motion

Text("Hello")
    .foregroundColor(colors.primary)     // 意味: プライマリカラー
    .padding(spacing.lg)                 // 意味: 大きめの余白
```

### Available Semantic Tokens

| Protocol | Environment Key | Description |
|----------|----------------|-------------|
| ``ColorPalette`` | `\.colorPalette` | カラーパレット（primary, surface, error等） |
| ``SpacingScale`` | `\.spacingScale` | スペーシング（xxs〜xxxl の10段階） |
| ``RadiusScale`` | `\.radiusScale` | 角丸（xs〜full の8段階） |
| ``Motion`` | `\.motion` | アニメーションタイミング |

## Layer 3: Component Tokens

コンポーネント固有のパラメータを定義します。
各コンポーネントに最適化された値のセットを提供します。

```swift
// ✅ Component Tokensを使用
Button("保存") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Card(elevation: .level2) {
    // ...
}

Chip("タグ", style: FilledChipStyle())
    .chipSize(.small)
```

### Available Component Tokens

| Token | Description |
|-------|-------------|
| ``ButtonSize`` | ボタンサイズ（small / medium / large） |
| ``ChipSize`` | チップサイズ（small / medium / large） |
| ``Elevation`` | 影のレベル（level0〜level5） |

## Topics

### Semantic Token Protocols

- ``ColorPalette``
- ``SpacingScale``
- ``RadiusScale``
- ``Typography``
- ``Motion``

### Component Tokens

- ``ButtonSize``
- ``ChipSize``
- ``Elevation``
