import SwiftUI

/// グラデーションを一級トークンとして表す値。色配列と方向を保持し、`LinearGradient` を生成する。
///
/// 収益アプリ（Instagram / Coinbase / Robinhood 等）はグラデーションを多用するが、
/// 既存ではコンポーネント内にインライン定義されていた。意味的グラデーションとして抽象化する。
public struct GradientToken: Sendable, Equatable {
    public var colors: [Color]
    public var startPoint: UnitPoint
    public var endPoint: UnitPoint

    public init(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    public var linearGradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }
}

/// 意味的グラデーションの集合。ブランドが固有のグラデーションを差し込む。
public protocol GradientTokens: Sendable {
    /// ブランドの主役グラデーション
    var brand: GradientToken { get }
    /// サーフェス（背景）用の控えめなグラデーション
    var surface: GradientToken { get }
    /// アクセント
    var accent: GradientToken { get }
}

/// 既定のグラデーション。ブランド未指定時のプレースホルダ（ブランドが override する前提）。
public struct DefaultGradientTokens: GradientTokens {
    public init() {}
    public var brand: GradientToken {
        GradientToken(colors: [PrimitiveColors.blue500, PrimitiveColors.purple500])
    }
    public var surface: GradientToken {
        GradientToken(colors: [PrimitiveColors.gray50, PrimitiveColors.gray100])
    }
    public var accent: GradientToken {
        GradientToken(colors: [PrimitiveColors.cyan500, PrimitiveColors.blue500])
    }
}
