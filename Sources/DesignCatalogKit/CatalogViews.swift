import SwiftUI
import DesignSystem

/// 1 エントリを**そのブランド自身のテーマ下で**描画する。
/// SmartHR のエントリは SmartHR テーマ（warm 色・広い行間）で出る。
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

/// 注釈付きのエントリカード（コンポーネント描画 + 「なぜ」）。
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

/// ギャラリー: 全エントリを archetype ごとにグルーピングして縦に並べる。
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

/// compare-mode: 1 つの archetype を選び、全ブランド実装を横並びで比較する（示唆の核心）。
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
