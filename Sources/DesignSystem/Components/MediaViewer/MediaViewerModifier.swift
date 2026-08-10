import SwiftUI

// The public API of MediaViewer.
// Reference: the grid item side of PhotoGridView from Kavsoft "iOS Photos App Style
// Transitions Using SwiftUI" (2026-03), which records sourceLocation, presents the
// fullScreenCover inside withoutAnimation and hides the source view, ported to a single view.

extension View {
    /// Opens a full screen media viewer when the view is tapped.
    ///
    /// The viewer expands from the position of the thumbnail, supports pinch to zoom, and
    /// closes when dragged downwards.
    ///
    /// - Note: This works on iOS 18 and later only. On macOS, tvOS, watchOS and on iOS 17
    ///   nothing is attached and the view keeps its existing behavior.
    ///
    /// - Parameters:
    ///   - item: The media to show when the view is tapped.
    ///   - enabled: Whether the viewer is active.
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
