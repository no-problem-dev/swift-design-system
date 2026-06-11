import SwiftUI
import DesignSystem

/// 2 テーマのトークン差分を表で見せる計器。差分のある行を強調する。
public struct TokenDiffView: View {
    private let titleA: String
    private let titleB: String
    private let typographyRows: [TokenDiff.Row]
    private let spacingRows: [TokenDiff.Row]
    private let radiusRows: [TokenDiff.Row]

    public init(_ a: any Theme, _ b: any Theme) {
        self.titleA = a.name
        self.titleB = b.name
        self.typographyRows = TokenDiff.typography(a.typographyScale, b.typographyScale)
        self.spacingRows = TokenDiff.spacing(a.spacingScale, b.spacingScale)
        self.radiusRows = TokenDiff.radius(a.radiusScale, b.radiusScale)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                section("Typography", typographyRows)
                section("Spacing", spacingRows)
                section("Radius", radiusRows)
            }
            .padding()
        }
    }

    private var header: some View {
        HStack {
            Text("Token").bold().frame(width: 120, alignment: .leading)
            Text(titleA).bold().frame(maxWidth: .infinity, alignment: .leading)
            Text(titleB).bold().frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.caption)
    }

    private func section(_ title: String, _ rows: [TokenDiff.Row]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline)
            ForEach(rows) { row in
                HStack {
                    Text(row.label).frame(width: 120, alignment: .leading).foregroundStyle(.secondary)
                    Text(row.a).frame(maxWidth: .infinity, alignment: .leading)
                    Text(row.b).frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.caption.monospaced())
                .padding(.vertical, 2)
                .background(row.differs ? Color.yellow.opacity(0.18) : Color.clear)
            }
        }
    }
}
