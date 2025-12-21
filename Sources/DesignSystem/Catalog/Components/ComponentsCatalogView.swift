import SwiftUI

/// コンポーネントカタログのエントリポイント
struct ComponentsCatalogView: View {
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacing

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                VStack(spacing: spacing.sm) {
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(colorPalette.primary)

                    Text("コンポーネントカタログ")
                        .typography(.headlineLarge)
                        .foregroundStyle(colorPalette.onBackground)

                    Text("再利用可能なUIコンポーネント")
                        .typography(.bodySmall)
                        .foregroundStyle(colorPalette.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, spacing.xl)

                // コンポーネントリスト
                VStack(alignment: .leading, spacing: 12) {
                    Text("コンポーネント")
                        .typography(.titleMedium)
                        .foregroundStyle(colorPalette.onSurface)
                        .padding(.horizontal, spacing.lg)

                    VStack(spacing: spacing.sm) {
                        ForEach(ComponentType.allCases) { component in
                            NavigationLink {
                                destinationView(for: component)
                            } label: {
                                HStack(spacing: spacing.md) {
                                    Image(systemName: component.icon)
                                        .font(.title3)
                                        .foregroundStyle(colorPalette.primary)
                                        .frame(width: 32)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(component.rawValue)
                                            .typography(.bodyLarge)
                                            .foregroundStyle(colorPalette.onSurface)

                                        Text(component.description)
                                            .typography(.bodySmall)
                                            .foregroundStyle(colorPalette.onSurfaceVariant)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(colorPalette.onSurfaceVariant)
                                }
                                .padding(.horizontal, spacing.lg)
                                .padding(.vertical, 12)
                                .background(colorPalette.surface)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, spacing.lg)
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colorPalette.background)
        .navigationTitle("コンポーネント")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private func destinationView(for component: ComponentType) -> some View {
        switch component {
        case .button:
            ButtonCatalogView()
        case .card:
            CardCatalogView()
        case .chip:
            ChipCatalogView()
        case .colorPicker:
            ColorPickerCatalogView()
        case .emojiPicker:
            EmojiPickerCatalogView()
        case .fab:
            FloatingActionButtonCatalogView()
        case .iconButton:
            IconButtonCatalogView()
        case .iconPicker:
            IconPickerCatalogView()
        case .imagePicker:
            #if canImport(UIKit)
            ImagePickerCatalogView()
            #else
            ContentUnavailableView {
                Label("iOS Only", systemImage: "iphone")
            } description: {
                Text("画像ピッカーはiOSでのみ利用可能です")
            }
            #endif
        case .snackbar:
            SnackbarCatalogView()
        case .textField:
            TextFieldCatalogView()
        case .videoPicker:
            #if canImport(UIKit)
            VideoPickerCatalogView()
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
            #else
            ContentUnavailableView {
                Label("iOS Only", systemImage: "iphone")
            } description: {
                Text("動画プレイヤーはiOSでのみ利用可能です")
            }
            #endif
        }
    }
}

#Preview {
    NavigationStack {
        ComponentsCatalogView()
            .theme(ThemeProvider())
    }
}
