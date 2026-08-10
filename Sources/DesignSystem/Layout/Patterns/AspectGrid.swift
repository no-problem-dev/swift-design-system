import SwiftUI

/// A grid whose items all share one aspect ratio, with the column count set by the available width.
///
/// Suits photo galleries, product lists, and media libraries, where items of different shapes would
/// leave a ragged edge. The item width floats between the minimum and maximum given, so the number
/// of columns changes with the screen while no single item grows past the maximum on an iPad.
/// Items are laid out lazily, so long collections stay cheap.
///
/// ## Examples
///
/// ### Product list
/// ```swift
/// AspectGrid(
///     minItemWidth: 140,
///     maxItemWidth: 180,
///     itemAspectRatio: 1,  // square
///     spacing: .md
/// ) {
///     ForEach(products) { product in
///         ProductCardView(product)
///     }
/// }
/// ```
///
/// ### Photo gallery
/// ```swift
/// AspectGrid(
///     minItemWidth: 160,
///     maxItemWidth: 200,
///     itemAspectRatio: 3/4,  // the usual photo proportion
///     spacing: .sm
/// ) {
///     ForEach(photos) { photo in
///         PhotoView(photo)
///     }
/// }
/// ```
///
/// ### Video thumbnails
/// ```swift
/// AspectGrid(
///     minItemWidth: 200,
///     maxItemWidth: 280,
///     itemAspectRatio: 16/9,  // the standard video proportion
///     spacing: .lg
/// ) {
///     ForEach(videos) { video in
///         VideoThumbnailView(video)
///     }
/// }
/// ```
///
/// ## Design guidelines
///
/// ### Choosing the aspect ratio
/// - **1:1 (1.0)**: product thumbnails, profile pictures, icons
/// - **3:4 (0.75)**: photographs and portraits
/// - **16:9 (1.78)**: video thumbnails and wide content
///
/// ### Choosing the item widths
/// - **minItemWidth**: the narrowest an item may get in a compact width, usually 80 to 160pt
/// - **maxItemWidth**: the widest an item may get on a large screen, usually 200 to 300pt
///
/// ### Choosing the spacing
/// - **.xs (8pt)**: dense icon grids
/// - **.sm (12pt)**: compact thumbnails
/// - **.md (16pt)**: the standard grid, and the default
/// - **.lg (20pt)**: a more open layout
/// - **.xl (24pt)**: showcase content
public struct AspectGrid<Content: View>: View {
    private let minItemWidth: CGFloat
    private let maxItemWidth: CGFloat
    private let itemAspectRatio: CGFloat
    private let spacing: GridSpacing
    private let alignment: HorizontalAlignment
    private let content: () -> Content

    /// Creates a grid whose items share one aspect ratio.
    ///
    /// - Parameters:
    ///   - minItemWidth: The narrowest an item may be, in points. A wider minimum means fewer
    ///     columns.
    ///   - maxItemWidth: The widest an item may be, in points, which keeps items from stretching
    ///     on a large screen.
    ///   - itemAspectRatio: The proportion every item is given, as width divided by height.
    ///   - spacing: The gap between items, both across and down. Defaults to `.md`.
    ///   - alignment: How the columns sit within the grid's width when they do not fill it.
    ///     Defaults to `.center`.
    ///   - content: The items to lay out.
    ///
    /// ## Example
    /// ```swift
    /// AspectGrid(
    ///     minItemWidth: 160,
    ///     maxItemWidth: 200,
    ///     itemAspectRatio: 2/3
    /// ) {
    ///     ForEach(items) { item in
    ///         ItemView(item)
    ///     }
    /// }
    /// ```
    public init(
        minItemWidth: CGFloat,
        maxItemWidth: CGFloat,
        itemAspectRatio: CGFloat,
        spacing: GridSpacing = .md,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minItemWidth = minItemWidth
        self.maxItemWidth = maxItemWidth
        self.itemAspectRatio = itemAspectRatio
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        LazyVGrid(
            columns: [
                GridItem(
                    .adaptive(
                        minimum: minItemWidth,
                        maximum: maxItemWidth
                    ),
                    spacing: spacing.value
                )
            ],
            alignment: alignment,
            spacing: spacing.value
        ) {
            content()
                .aspectRatio(itemAspectRatio, contentMode: .fit)
        }
    }
}

// MARK: - Previews

#Preview("Book Covers") {
    ScrollView {
        AspectGrid(
            minItemWidth: 120,
            maxItemWidth: 160,
            itemAspectRatio: 2/3,
            spacing: .md
        ) {
            ForEach(0..<12, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.3))
                    .overlay {
                        Text("\(index + 1)")
                            .font(.title)
                            .foregroundColor(.white)
                    }
            }
        }
        .padding()
    }
}

#Preview("Square Icons") {
    ScrollView {
        AspectGrid(
            minItemWidth: 60,
            maxItemWidth: 80,
            itemAspectRatio: 1,
            spacing: .xs
        ) {
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .overlay {
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                    }
            }
        }
        .padding()
    }
}

#Preview("Movie Posters") {
    ScrollView {
        AspectGrid(
            minItemWidth: 140,
            maxItemWidth: 200,
            itemAspectRatio: 3/4,
            spacing: .lg
        ) {
            ForEach(0..<8, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.purple.opacity(0.3))
                    .overlay {
                        VStack {
                            Image(systemName: "film")
                                .font(.largeTitle)
                            Text("Movie \(index + 1)")
                        }
                        .foregroundColor(.white)
                    }
            }
        }
        .padding()
    }
}
