# ``DesignCatalogKit``

ブランド横断のデザインギャラリー・トークン比較・示唆注釈を提供するカタログ基盤ライブラリ。

## Overview

DesignCatalogKit は、複数ブランドのデザインシステムを「可視化して示唆を得る」計器の枠組みを提供します。各ブランドは ``CatalogEntry`` を登録し、archetype（比較軸）単位でサイドバイサイド比較やギャラリー表示が可能になります。

```swift
// ブランドのカタログエントリを作成
let entry = CatalogEntry(
    id: "smarthr-form-control",
    brandId: "smarthr",
    brandName: "SmartHR",
    archetype: "FormControl",
    title: "SmartHR フォームコントロール",
    annotation: DesignAnnotation(
        purpose: "フォーム入力の標準パターン",
        whyItWorks: "ラベル位置・エラー表示を一貫化し、入力完了率を向上させる"
    ),
    theme: SmartHRTheme()
) {
    DSTextField("名前", text: .constant("田中 一郎"))
}

// archetype ごとにグルーピングして比較
let entries: [CatalogEntry] = [/* ... */]
let grouped = entries.groupedByArchetype()

// トークン差分を取得
let typoDiff = TokenDiff.typography(themeA.typographyScale, themeB.typographyScale)
let diffOnly = TokenDiff.differing(typoDiff)
```

## Topics

### エントリモデル

- ``CatalogEntry``
- ``DesignAnnotation``

### ビュー

- ``CatalogEntryCard``
- ``CatalogGalleryView``
- ``CatalogCompareView``
- ``ThemedEntryView``

### トークン差分

- ``TokenDiff``
- ``TokenDiffView``
