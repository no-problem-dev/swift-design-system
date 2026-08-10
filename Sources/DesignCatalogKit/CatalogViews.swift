import SwiftUI
import DesignSystem

/// Draws a single entry under that entry's own brand theme.
///
/// A SmartHR entry comes out in the SmartHR theme, with its warm colors and generous leading.
public struct ThemedEntryView: View {
    private let entry: CatalogEntry
    @State private var provider: ThemeProvider

    public init(_ entry: CatalogEntry) {
        self.entry = entry
        _provider = State(initialValue: ThemeProvider(initialTheme: entry.theme))
    }

    public var body: some View {
        entry.content
            .theme(provider)
    }
}

/// A card that shows an entry's component together with the reasoning behind it.
public struct CatalogEntryCard: View {
    private let entry: CatalogEntry
    public init(_ entry: CatalogEntry) { self.entry = entry }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.title).font(.headline)
                Spacer()
                Text(entry.brandName).font(.caption).foregroundStyle(.secondary)
            }
            ThemedEntryView(entry)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.06)))

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.annotation.purpose).font(.caption).bold()
                Text(entry.annotation.whyItWorks).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: 360, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
    }
}

/// A gallery that stacks every entry vertically, grouped by archetype.
public struct CatalogGalleryView: View {
    private let entries: [CatalogEntry]
    public init(_ entries: [CatalogEntry]) { self.entries = entries }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(entries.groupedByArchetype(), id: \.archetype) { group in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(group.archetype).font(.title3).bold()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 16) {
                                ForEach(group.entries) { CatalogEntryCard($0) }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

/// Compare mode: shows how every brand implements one archetype, side by side.
///
/// This is where the comparison pays off, since the differences sit next to each other.
public struct CatalogCompareView: View {
    private let archetype: String
    private let entries: [CatalogEntry]

    public init(archetype: String, in entries: [CatalogEntry]) {
        self.archetype = archetype
        self.entries = entries.entries(ofArchetype: archetype)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Compare · \(archetype)").font(.title3).bold()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(entries) { CatalogEntryCard($0) }
                }
            }
        }
        .padding()
    }
}
