import SwiftUI

extension View {
    func applyTheme() -> some View {
        self
            .background(Color.primaryBackground)
            .foregroundColor(Color.secondaryBackground)
    }
}
