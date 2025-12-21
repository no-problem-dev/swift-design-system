import SwiftUI

/// カタログの詳細ビュー
/// NavigationSplitViewの最後のカラムで、選択されたアイテムの詳細を表示
struct CatalogDetailView: View {
    let category: CatalogCategory?
    let foundationItem: FoundationItem?
    let componentItem: ComponentType?
    let patternItem: PatternItem?

    var body: some View {
        Group {
            if let category {
                switch category {
                case .themes:
                    ThemeGalleryView()
                case .foundations:
                    foundationDetailView
                case .components:
                    componentDetailView
                case .patterns:
                    patternDetailView
                }
            } else {
                emptyStateView
            }
        }
    }

    @ViewBuilder
    private var foundationDetailView: some View {
        if let item = foundationItem {
            switch item {
            case .colors:
                ColorsCatalogView()
                    .id(item)
            case .typography:
                TypographyCatalogView()
                    .id(item)
            case .spacing:
                SpacingCatalogView()
                    .id(item)
            case .radius:
                RadiusCatalogView()
                    .id(item)
            case .motion:
                MotionCatalogView()
                    .id(item)
            }
        } else {
            itemSelectionPrompt
        }
    }

    @ViewBuilder
    private var componentDetailView: some View {
        if let component = componentItem {
            switch component {
            case .button:
                ButtonCatalogView()
                    .id(component)
            case .card:
                CardCatalogView()
                    .id(component)
            case .chip:
                ChipCatalogView()
                    .id(component)
            case .colorPicker:
                ColorPickerCatalogView()
                    .id(component)
            case .emojiPicker:
                EmojiPickerCatalogView()
                    .id(component)
            case .fab:
                FloatingActionButtonCatalogView()
                    .id(component)
            case .iconButton:
                IconButtonCatalogView()
                    .id(component)
            case .iconPicker:
                IconPickerCatalogView()
                    .id(component)
            case .imagePicker:
                #if canImport(UIKit)
                ImagePickerCatalogView()
                    .id(component)
                #else
                ContentUnavailableView {
                    Label("iOS Only", systemImage: "iphone")
                } description: {
                    Text("画像ピッカーはiOSでのみ利用可能です")
                }
                #endif
            case .snackbar:
                SnackbarCatalogView()
                    .id(component)
            case .textField:
                TextFieldCatalogView()
                    .id(component)
            case .videoPicker:
                #if canImport(UIKit)
                VideoPickerCatalogView()
                    .id(component)
                #else
                ContentUnavailableView {
                    Label("iOS Only", systemImage: "iphone")
                } description: {
                    Text("動画ピッカーはiOSでのみ利用可能です")
                }
                #endif
            case .videoPlayer:
                #if canImport(UIKit)
                VideoPlayerCatalogView()
                    .id(component)
                #else
                ContentUnavailableView {
                    Label("iOS Only", systemImage: "iphone")
                } description: {
                    Text("動画プレイヤーはiOSでのみ利用可能です")
                }
                #endif
            }
        } else {
            itemSelectionPrompt
        }
    }

    @ViewBuilder
    private var patternDetailView: some View {
        if let pattern = patternItem {
            switch pattern {
            case .aspectGrid:
                AspectGridCatalogView()
                    .id(pattern)
            case .sectionCard:
                SectionCardCatalogView()
                    .id(pattern)
            }
        } else {
            itemSelectionPrompt
        }
    }

    private var itemSelectionPrompt: some View {
        ZStack {
            Color.clear
            ContentUnavailableView {
                Label("アイテムを選択", systemImage: "doc.text.fill")
            } description: {
                Text("コンテンツリストからアイテムを選択してください")
            }
        }
    }

    private var emptyStateView: some View {
        ZStack {
            Color.clear
            ContentUnavailableView {
                Label("カタログを探索", systemImage: "book.fill")
            } description: {
                Text("サイドバーからカテゴリを選択して開始してください")
            }
        }
    }
}

#Preview("Empty State") {
    CatalogDetailView(
        category: nil,
        foundationItem: nil,
        componentItem: nil,
        patternItem: nil
    )
    .theme(ThemeProvider())
}

#Preview("Theme Gallery") {
    CatalogDetailView(
        category: .themes,
        foundationItem: nil,
        componentItem: nil,
        patternItem: nil
    )
    .theme(ThemeProvider())
}

#Preview("Foundation Item") {
    CatalogDetailView(
        category: .foundations,
        foundationItem: .colors,
        componentItem: nil,
        patternItem: nil
    )
    .theme(ThemeProvider())
}
