# トークンアーキテクチャ

3 層トークンシステムの設計思想と使い分け。

## Overview

DesignSystem は **Primitive → Semantic → Component** の 3 層トークンアーキテクチャを採用している。
各層には明確な役割があり、適切な層のトークンを使うことで保守性と一貫性を担保する。

## レイヤー 1: プリミティブトークン

生の値（色の HEX コード、スペーシングの pt 値など）を定義する。

> Warning: Primitive Tokens は内部実装の詳細。View 内で直接使用しないこと。

```swift
// ❌ 直接使用しない
PrimitiveColors.blue500
PrimitiveSpacing.space16
PrimitiveRadius.radius8
```

## レイヤー 2: セマンティックトークン

意味のあるトークンをプロトコルで定義する。
テーマやモードの切り替えに対応するため、**必ずこの層を使用すること**。

Environment から取得して使用する:

```swift
// ✅ Semantic Tokens を使用
@Environment(\.colorPalette) var colors
@Environment(\.spacingScale) var spacing
@Environment(\.radiusScale) var radius
@Environment(\.motion) var motion

Text("Hello")
    .foregroundColor(colors.primary)     // 意味: プライマリカラー
    .padding(spacing.lg)                 // 意味: 大きめの余白
```

### 利用可能なセマンティックトークン

| Protocol | Environment Key | Description |
|----------|----------------|-------------|
| ``ColorPalette`` | `\.colorPalette` | カラーパレット（primary, surface, error 等） |
| ``SpacingScale`` | `\.spacingScale` | スペーシング（xxs〜xxxl の 10 段階） |
| ``RadiusScale`` | `\.radiusScale` | 角丸（xs〜full の 8 段階） |
| ``Motion`` | `\.motion` | アニメーションタイミング |

## レイヤー 3: コンポーネントトークン

コンポーネント固有のパラメータを定義する。
各コンポーネントに最適化された値のセットを提供する。

```swift
// ✅ Component Tokens を使用
Button("保存") { save() }
    .buttonStyle(.primary)
    .buttonSize(.large)

Card(elevation: .level2) {
    // ...
}

Chip("タグ")
    .chipStyle(.filled)
    .chipSize(.small)
```

### 利用可能なコンポーネントトークン

| Token | Description |
|-------|-------------|
| ``ButtonSize`` | ボタンサイズ（small / medium / large） |
| ``ChipSize`` | チップサイズ（small / medium / large） |
| ``Elevation`` | 影のレベル（level0〜level5） |

## Topics

### セマンティックトークンプロトコル

- ``ColorPalette``
- ``SpacingScale``
- ``RadiusScale``
- ``Typography``
- ``Motion``

### コンポーネントトークン

- ``ButtonSize``
- ``ChipSize``
- ``Elevation``
