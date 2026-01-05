import SwiftUI

/// コンポーネントカタログのエントリポイント
struct ComponentsCatalogView: View {
    @Environment(\.colorPalette) private var colors
    @Environment(\.spacingScale) private var spacing
    @Environment(\.radiusScale) private var radius

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // ヘッダー
                VStack(spacing: spacing.sm) {
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(colors.primary)

                    Text("コンポーネントカタログ")
                        .typography(.headlineLarge)
                        .foregroundStyle(colors.onBackground)

                    Text("再利用可能なUIコンポーネント")
                        .typography(.bodySmall)
                        .foregroundStyle(colors.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, spacing.xl)

                // コンポーネントリスト
                VStack(alignment: .leading, spacing: spacing.md) {
                    Text("コンポーネント")
                        .typography(.titleMedium)
                        .foregroundStyle(colors.onSurface)
                        .padding(.horizontal, spacing.lg)

                    VStack(spacing: spacing.sm) {
                        ForEach(ComponentType.allCases) { component in
                            NavigationLink {
                                destinationView(for: component)
                            } label: {
                                HStack(spacing: spacing.md) {
                                    Image(systemName: component.icon)
                                        .typography(.titleSmall)
                                        .foregroundStyle(colors.primary)
                                        .frame(width: 32)

                                    VStack(alignment: .leading, spacing: spacing.xs) {
                                        Text(component.rawValue)
                                            .typography(.bodyLarge)
                                            .foregroundStyle(colors.onSurface)

                                        Text(component.description)
                                            .typography(.bodySmall)
                                            .foregroundStyle(colors.onSurfaceVariant)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .typography(.labelSmall)
                                        .foregroundStyle(colors.onSurfaceVariant)
                                }
                                .padding(.horizontal, spacing.lg)
                                .padding(.vertical, spacing.md)
                                .background(colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: radius.md))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, spacing.lg)
                }
            }
            .padding(.bottom, spacing.xl)
        }
        .background(colors.background)
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
        case .iconBadge:
            IconBadgeCatalogView()
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
        case .progressBar:
            ProgressBarCatalogView()
        case .snackbar:
            SnackbarCatalogView()
        case .statDisplay:
            StatDisplayCatalogView()
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
