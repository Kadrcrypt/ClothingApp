import Foundation
import Supabase

// Модель для стилей одежды
struct ApparelStyle: Identifiable, Codable {
    var id: UUID
    var name: String
    var tags: [String]
}

@MainActor
class ClothingViewModel: ObservableObject {
    @Published var clothingStyles: [ApparelStyle] = []
    @Published var dislikedTags: [String] = []
    @Published var isAuthenticated: Bool = false 

    var filteredClothingStyles: [ApparelStyle] {
        clothingStyles.filter { style in
            !style.tags.contains(where: dislikedTags.contains)
        }
    }

    func loadClothingStyles() async {
        // Загрузка стилей одежды...
    }

    func updateAuthenticationState(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
}
