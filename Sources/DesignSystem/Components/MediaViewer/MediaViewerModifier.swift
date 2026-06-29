import SwiftUI

// MediaViewer の公開 API。
// 参照: Kavsoft「iOS Photos App Style Transitions Using SwiftUI」(2026-03) の
// PhotoGridView グリッドアイテム側（sourceLocation 記録 + withoutAnimation での
// fullScreenCover 表示 + ソースビュー非表示）を単一ビュー版に移植。

extension View {
    /// タップでフルスクリーンメディアビューアを開く
    ///
    /// サムネイル位置からのヒーロー展開・ピンチズーム・下方向ドラッグでの
    /// 閉じる操作を備えたフルスクリーンビューアを表示する。
    ///
    /// - Note: iOS 18 以降でのみ動作する。macOS / tvOS / watchOS および
    ///   iOS 17 では何も付与されません（従来挙動のまま）。
    ///
    /// - Parameters:
    ///   - item: タップ時に表示するメディア
    ///   - enabled: ビューアを有効にするか（デフォルト true）
    /// - Returns: ビューア起動が付与されたビュー
    @ViewBuilder
    public func mediaViewable(_ item: MediaViewerItem, enabled: Bool = true) -> some View {
        #if os(iOS)
        if #available(iOS 18.0, *) {
            modifier(MediaViewableModifier(item: item, enabled: enabled))
        } else {
            self
        }
        #else
        self
        #endif
    }
}

#if os(iOS)
@available(iOS 18.0, *)
private struct MediaViewableModifier: ViewModifier {
    var item: MediaViewerItem
    var enabled: Bool
    /// View Properties
    @State private var config: MediaViewerConfig = .init()
    func body(content: Content) -> some View {
        content
            /// Hiding the source view when the hero effect is enabled
            .opacity(config.selectedItem == item ? 0 : 1)
            .overlay {
                if enabled {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        let updatedRect: CGRect? = config.selectedItem == item ? rect : nil

                        Color.clear
                            .contentShape(.rect)
                            .onTapGesture {
                                /// Storing info and opening full screen hero view
                                config.selectedItem = item
                                config.sourceLocation = rect
                                /// Opening Full screen cover without animation
                                withoutAnimation {
                                    config.showFullScreenCover = true
                                }
                            }
                            /// Updating the source location when the source view moves
                            .onChange(of: updatedRect) { oldValue, newValue in
                                if let newValue {
                                    config.sourceLocation = newValue
                                }
                            }
                    }
                }
            }
            .fullScreenCover(isPresented: $config.showFullScreenCover) {
                config.selectedItem = nil
            } content: {
                MediaViewerDetailView(config: $config, items: [item])
            }
    }
}
#endif
