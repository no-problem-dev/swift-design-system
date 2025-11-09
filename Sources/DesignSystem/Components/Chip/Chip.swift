import SwiftUI

/// Chipコンポーネント
///
/// ステータス表示、カテゴリ、フィルター、ユーザー入力など、様々な用途で使用できる
/// コンパクトなラベルコンポーネントです。
///
/// ## 基本的な使用例
/// ```swift
/// // シンプルなチップ
/// Chip("Active")
///     .chipStyle(.filled)
///     .foregroundColor(.blue)
///
/// // アイコン付きチップ
/// Chip("完了", systemImage: "checkmark.circle.fill")
///     .chipStyle(.filled)
///     .foregroundColor(.green)
///
/// // 削除可能なチップ
/// Chip("Swift", systemImage: "tag.fill") {
///     removeTag("Swift")
/// }
/// .chipStyle(.filled)
///
/// // 選択可能なフィルターチップ
/// Chip("フィルター", systemImage: "line.3.horizontal.decrease", isSelected: $isFiltered)
///     .chipStyle(.outlined)
/// ```
///
/// ## スタイルバリアント
/// - **Filled**: 塗りつぶし背景（デフォルト）
/// - **Outlined**: 境界線のみ
/// - **Liquid Glass**: 半透明のガラス効果
///
/// ## サイズバリアント
/// - **Small**: 24pt高さ、密集レイアウト向け
/// - **Medium**: 32pt高さ、標準的な用途（デフォルト）
public struct Chip: View {
    @Environment(\.chipStyle) private var chipStyle
    @Environment(\.chipSize) private var size
    @Environment(\.colorPalette) private var colorPalette
    @Environment(\.spacingScale) private var spacingScale
    @Environment(\.radiusScale) private var radiusScale
    @Environment(\.motion) private var motion

    private let label: String
    private let systemImage: String?
    private let onDelete: (() -> Void)?
    private let isSelectable: Bool
    @Binding private var isSelected: Bool
    @State private var isPressed: Bool = false

    // MARK: - Initializers

    /// テキストのみのChipを作成
    /// - Parameter label: 表示するテキスト
    public init(_ label: String) {
        self.label = label
        self.systemImage = nil
        self.onDelete = nil
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// アイコン付きChipを作成
    /// - Parameters:
    ///   - label: 表示するテキスト
    ///   - systemImage: SF Symbolsのアイコン名
    public init(_ label: String, systemImage: String) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = nil
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// 削除可能なChipを作成（Input Chip）
    /// - Parameters:
    ///   - label: 表示するテキスト
    ///   - systemImage: SF Symbolsのアイコン名（オプション）
    ///   - onDelete: 削除ボタンタップ時のハンドラ
    public init(
        _ label: String,
        systemImage: String? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = onDelete
        self.isSelectable = false
        self._isSelected = .constant(false)
    }

    /// 選択可能なChipを作成（Filter Chip）
    /// - Parameters:
    ///   - label: 表示するテキスト
    ///   - systemImage: SF Symbolsのアイコン名（オプション）
    ///   - isSelected: 選択状態のバインディング
    public init(
        _ label: String,
        systemImage: String? = nil,
        isSelected: Binding<Bool>
    ) {
        self.label = label
        self.systemImage = systemImage
        self.onDelete = nil
        self.isSelectable = true
        self._isSelected = isSelected
    }

    // MARK: - Body

    public var body: some View {
        let configuration = ChipStyleConfiguration(
            label: AnyView(Text(label)),
            icon: systemImage.map { AnyView(Image(systemName: $0)) },
            onDelete: onDelete,
            isSelected: isSelected,
            isPressed: isPressed,
            size: size,
            colorPalette: colorPalette,
            spacingScale: spacingScale,
            radiusScale: radiusScale,
            motion: motion
        )

        Group {
            if onDelete != nil || isSelectable {
                // タップ可能なチップ（削除または選択）
                Button(action: handleTap) {
                    chipStyle.makeBody(configuration: configuration)
                }
                .buttonStyle(ChipButtonStyle(isPressed: $isPressed))
            } else {
                // 静的なチップ
                chipStyle.makeBody(configuration: configuration)
            }
        }
    }

    // MARK: - Private Methods

    private func handleTap() {
        if let onDelete = onDelete {
            // 削除アクション
            onDelete()
        } else {
            // 選択トグル
            withAnimation(motion.toggle) {
                isSelected.toggle()
            }
        }
    }
}

// MARK: - ChipButtonStyle

/// Chipのボタンスタイル（タップ時のフィードバック用）
private struct ChipButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Previews

#Preview("Basic Chips") {
    VStack(spacing: 16) {
        Chip("Active")
            .chipStyle(.filled)
            .foregroundColor(.blue)

        Chip("完了", systemImage: "checkmark.circle.fill")
            .chipStyle(.filled)
            .foregroundColor(.green)

        Chip("New", systemImage: "bell.fill")
            .chipStyle(.filled)
            .chipSize(.small)
            .foregroundColor(.orange)
    }
    .padding()
}

#Preview("Deletable Chips") {
    VStack(spacing: 16) {
        Chip("Swift", systemImage: "tag.fill") {
            print("Delete Swift")
        }
        .chipStyle(.filled)
        .foregroundColor(.blue)

        Chip("SwiftUI") {
            print("Delete SwiftUI")
        }
        .chipStyle(.filled)
        .chipSize(.small)
        .foregroundColor(.purple)
    }
    .padding()
}

#Preview("Selectable Chips") {
    struct SelectableChipExample: View {
        @State private var isSelected1 = false
        @State private var isSelected2 = true

        var body: some View {
            VStack(spacing: 16) {
                Chip("フィルター", systemImage: "line.3.horizontal.decrease", isSelected: $isSelected1)
                    .chipStyle(.outlined)

                Chip("お気に入り", systemImage: "star.fill", isSelected: $isSelected2)
                    .chipStyle(.outlined)
            }
            .padding()
        }
    }

    return SelectableChipExample()
}
