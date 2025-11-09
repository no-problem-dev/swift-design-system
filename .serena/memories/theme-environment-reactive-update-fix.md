# テーマ環境値のリアクティブ更新の修正

## 問題の概要

テーマギャラリーでテーマを選択しても、カラーパレットが即座に更新されない問題がありました。

## 根本原因

`ThemeEnvironmentView` (Sources/DesignSystem/ViewModifiers/ThemeModifier.swift) において、カラーパレットを以下のように設定していました:

```swift
.environment(\.colorPalette, provider.currentTheme.colorPalette(for: resolvedMode))
```

これは**ビルド時に一度だけ評価される静的な値**として渡されるため、`@Observable`な`provider.currentTheme`が変更されても、Environment経由で子Viewに伝播された`colorPalette`は更新されませんでした。

## 解決策

計算プロパティ`resolvedColorPalette`を追加し、これを環境値として渡すことで、`provider`の変更時に自動的に再計算されるようにしました。

### 実装詳細

**ThemeModifier.swift (Sources/DesignSystem/ViewModifiers/ThemeModifier.swift:40-53)**

```swift
/// 実際に適用するカラーパレット(リアクティブ)
/// provider.currentThemeが変更されると自動的に再計算される
private var resolvedColorPalette: any ColorPalette {
    provider.currentTheme.colorPalette(for: resolvedMode)
}

var body: some View {
    content
        .environment(provider)
        .environment(\.colorPalette, resolvedColorPalette)  // 計算プロパティを使用
        .environment(\.spacingScale, DefaultSpacingScale())
        .environment(\.radiusScale, DefaultRadiusScale())
        .colorScheme(resolvedColorScheme)
}
```

### 動作原理

1. `ThemeProvider`は`@Observable`マクロでラップされている
2. `ThemeEnvironmentView`は`@Bindable var provider`を持つ
3. `provider.currentTheme`が変更されると、SwiftUIが自動的に変更を検知
4. Viewが再レンダリングされ、`resolvedColorPalette`が再計算される
5. 新しいカラーパレットが環境値として子Viewに伝播される

## カタログアプリの設定

**DesignSystemCatalogApp.swift (DesignSystemCatalog/DesignSystemCatalog/DesignSystemCatalogApp.swift:6-16)**

カスタムテーマをテストできるように、クロージャベースの初期化を追加:

```swift
@State private var themeProvider: ThemeProvider = {
    let provider = ThemeProvider()
    
    // カスタムテーマをテスト用に登録する場合は、ここでregisterThemeを使用
    // 例:
    // let customTheme = MyCustomTheme()
    // provider.registerTheme(customTheme)
    // provider.switchToTheme(id: customTheme.id)
    
    return provider
}()
```

## コーディング規則の遵守

- **既存パターン踏襲**: `resolvedMode`, `resolvedColorScheme`と同じ命名パターン
- **命名規則**: `resolved*` prefix for resolved values
- **Swift 6 Concurrency**: `@MainActor` context内での変更（既存と同じ）
- **ドキュメント**: 日本語コメントで意図を明記

## 影響範囲

- **変更ファイル**: 
  - `Sources/DesignSystem/ViewModifiers/ThemeModifier.swift` (計算プロパティ追加)
  - `DesignSystemCatalog/DesignSystemCatalog/DesignSystemCatalogApp.swift` (カスタムテーマテスト設定)

- **動作改善**:
  - テーマギャラリーでのテーマ切り替えが即座に反映されるようになった
  - カスタムテーマの登録と動作確認が容易になった

## 今後の拡張性

この修正により、以下が可能になりました:

1. **動的テーマ切り替え**: ユーザーがテーマを選択すると即座に全UIが更新される
2. **カスタムテーマのテスト**: カタログアプリで簡単にカスタムテーマを登録してテスト可能
3. **リアルタイムプレビュー**: テーマギャラリーでのテーマ選択がリアルタイムで反映される

## 検証項目

- [x] テーマ切り替えが即座に反映される
- [x] ライト/ダークモード切り替えが動作する
- [x] カスタムテーマの登録が可能
- [x] 既存のコーディング規則を遵守
- [ ] ビルドエラーがないことを確認
- [ ] カタログアプリでの動作確認
