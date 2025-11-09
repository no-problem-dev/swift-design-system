# テーマギャラリーの動的テーマ表示修正

## 問題

カタログアプリで`provider.registerTheme()`を使ってカスタムテーマを登録しても、テーマギャラリーに表示されない問題がありました。

## 根本原因

`ThemeGalleryView` (Sources/DesignSystem/Catalog/Themes/ThemeGalleryView.swift:44) で、テーマ一覧を表示する際に`ThemeRegistry.themesByCategory`を使用していました。

```swift
// 修正前（間違い）
ForEach(ThemeCategory.allCases) { category in
    if let themes = ThemeRegistry.themesByCategory[category], !themes.isEmpty {
        ThemeCategorySection(category: category, themes: themes)
    }
}
```

`ThemeRegistry.themesByCategory`は**ビルトインテーマのみ**を返す静的なプロパティで、実行時に登録されたカスタムテーマは含まれません。

## 解決策

`themeProvider.availableThemes`を使用して、実行時に登録された全テーマ（ビルトイン + カスタム）を動的に取得するように変更しました。

```swift
// 修正後（正しい）
ForEach(ThemeCategory.allCases) { category in
    let categoryThemes = themeProvider.availableThemes.filter { $0.category == category }
    if !categoryThemes.isEmpty {
        ThemeCategorySection(category: category, themes: categoryThemes)
    }
}
```

## 変更内容

**ファイル**: Sources/DesignSystem/Catalog/Themes/ThemeGalleryView.swift:43-51

- `ThemeRegistry.themesByCategory[category]` → `themeProvider.availableThemes.filter { $0.category == category }`
- これにより、`ThemeProvider`に登録された全てのテーマ（ビルトイン + カスタム）が表示されるようになった

## 動作確認

カタログアプリ（DesignSystemCatalogApp.swift）で以下のようにカスタムテーマを登録:

```swift
@State private var themeProvider: ThemeProvider = {
    let provider = ThemeProvider()
    
    // カスタムテーマを登録
    provider.registerTheme(SimpleBlueTheme())
    provider.registerTheme(SimpleRedTheme())
    
    return provider
}()
```

これにより、テーマギャラリーに以下が表示されます:
- **Standard**: Default
- **Brand Personality**: Ocean, Forest, Sunset, Purple Haze, Monochrome, **テストブルー**, **テストレッド**
- **Accessibility**: High Contrast

## 今後の拡張性

この修正により:
1. **動的テーマ登録**: アプリ起動時やランタイムに`registerTheme()`でテーマを追加可能
2. **カスタムカテゴリ**: 独自の`ThemeCategory`も追加可能
3. **プラグイン対応**: 外部からテーマを読み込んで登録することも可能

## ThemeRegistryの役割

`ThemeRegistry`は変更していません。その役割は:
- ビルトインテーマのデフォルトセットを提供
- `ThemeProvider`の初期化時にデフォルトテーマを提供
- IDでビルトインテーマを検索する補助機能

動的なテーマ管理は`ThemeProvider.availableThemes`が担当します。
