import SwiftUI

/// カタログアイテム
struct CatalogItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let description: String
}
