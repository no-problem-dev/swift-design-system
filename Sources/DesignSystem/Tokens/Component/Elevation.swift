import SwiftUI

/// Elevationレベル（高さ/影）
///
/// 一貫した影のスタイリングを提供し、UI 要素の階層と重要度を視覚的に表現する。
/// レベルが高いほど要素が手前に浮き上がって見える。
///
/// ## 使用例
/// ```swift
/// Card {
///     Text("カード内容")
/// }
/// .elevation(.level2)  // 標準的な影
///
/// RoundedRectangle(cornerRadius: 12)
///     .fill(Color.white)
///     .frame(width: 200, height: 100)
///     .elevation(.level3)  // 中程度の影
/// ```
///
/// ## レベルの使い分け
/// - **Level 0**: 影なし - 埋め込み要素
/// - **Level 1**: 軽い影 - リスト項目、軽いカード
/// - **Level 2**: 標準的な影 - カード、パネル（推奨）
/// - **Level 3**: 中程度の影 - 浮き上がったカード
/// - **Level 4**: 強い影 - モーダル、ポップアップ
/// - **Level 5**: 最大の影 - ドロワー、重要なダイアログ
public enum Elevation {
    /// 影なし
    case level0

    /// 軽い影 - リスト項目、軽いカード
    case level1

    /// 標準的な影 - カード、パネル
    case level2

    /// 中程度の影 - 浮き上がったカード
    case level3

    /// 強い影 - モーダル、ポップアップ
    case level4

    /// 最大の影 - ドロワー、重要なダイアログ
    case level5

    // MARK: - Shadow Properties

    /// 影のぼかし半径
    public var radius: CGFloat {
        switch self {
        case .level0: return 0
        case .level1: return 3
        case .level2: return 6
        case .level3: return 8
        case .level4: return 10
        case .level5: return 12
        }
    }

    /// 影のオフセット
    public var offset: CGSize {
        switch self {
        case .level0: return .zero
        case .level1: return CGSize(width: 0, height: 1)
        case .level2: return CGSize(width: 0, height: 2)
        case .level3: return CGSize(width: 0, height: 4)
        case .level4: return CGSize(width: 0, height: 6)
        case .level5: return CGSize(width: 0, height: 8)
        }
    }

    /// 影の不透明度（ライトモード）
    public var opacity: Double {
        switch self {
        case .level0: return 0
        case .level1: return 0.08
        case .level2: return 0.10
        case .level3: return 0.12
        case .level4: return 0.14
        case .level5: return 0.16
        }
    }

    /// ダークモード用の不透明度調整
    /// ダークモードでは黒い影よりも surface の明度差で奥行きを表現する。影は控えめ。
    public func opacity(for colorScheme: ColorScheme) -> Double {
        colorScheme == .dark ? opacity * 0.55 : opacity
    }

    /// Elevated surfaceに重ねるtintの不透明度。
    public func surfaceTintOpacity(for colorScheme: ColorScheme) -> Double {
        switch self {
        case .level0:
            return 0
        case .level1:
            return colorScheme == .dark ? 0.03 : 0.015
        case .level2:
            return colorScheme == .dark ? 0.04 : 0.02
        case .level3:
            return colorScheme == .dark ? 0.05 : 0.025
        case .level4:
            return colorScheme == .dark ? 0.06 : 0.03
        case .level5:
            return colorScheme == .dark ? 0.07 : 0.035
        }
    }
}
