# ``DesignSpec``

ブランドデザイン仕様を機械可読なモデルとして表現する、SwiftUI 非依存の純データライブラリ。

## Overview

DesignSpec は、`DESIGN.md` 9 セクション（ブランドメタ・ビジュアルテーマ・カラー・タイポグラフィ・スペーシング・角丸・エレベーション・レイアウト・コンポーネント）を Codable モデルに移植したライブラリです。

SwiftUI・UIKit・AppKit への依存を持たず、純粋な Foundation + Swift 標準ライブラリのみで動作します。CLI によるデザイン仕様の生成・検証・差分・取り込みが可能です。

```swift
let spec = DesignSpec(
    meta: BrandMeta(id: "my-brand", name: "My Brand"),
    theme: VisualTheme(
        atmosphere: ["modern", "trustworthy"],
        summary: "クリーンでアクセシブルなデザイン"
    ),
    color: ColorSpec(primitives: [], roles: [], states: []),
    typography: TypographySpec(
        fontStack: FontStack(primaryFamily: "system", fallback: []),
        scaleModel: .modular(base: 16, ratio: 1.25),
        styles: []
    ),
    spacing: SpacingSpec(model: .absolute, steps: []),
    radius: RadiusSpec(steps: []),
    elevation: ElevationSpec(layers: []),
    layout: LayoutSpec(),
    components: [],
    guidance: Guidance(dos: [], donts: [])
)

// JSON へのエンコード
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let data = try encoder.encode(spec)
```

## Topics

### ルートモデル

- ``DesignSpec``
- ``BrandMeta``
- ``VisualTheme``

### カラー

- ``ColorSpec``
- ``ColorToken``
- ``ColorRole``
- ``ColorState``
- ``ColorTransform``

### タイポグラフィ

- ``TypographySpec``
- ``FontStack``
- ``TypeStyle``
- ``ScaleModel``
- ``FontWeightToken``
- ``LeadingToken``

### スペーシング・角丸

- ``SpacingSpec``
- ``SpacingModel``
- ``SpacingStep``
- ``RadiusSpec``
- ``RadiusStep``

### エレベーション・レイアウト

- ``ElevationSpec``
- ``ElevationLayer``
- ``FocusRing``
- ``LayoutSpec``
- ``Breakpoint``

### コンポーネント・ガイダンス

- ``ComponentSpec``
- ``Guidance``
