import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @StateObject private var viewModel = ClothingViewModel()
    @Binding var isAuthenticated: Bool

    var body: some View {
        NavigationView {
            List(viewModel.filteredClothingStyles) { style in
                ClothingStyleView(style: style, viewModel: viewModel)
            }
            .navigationTitle("Стиль одежды")
            .onAppear {
                Task {
                    await viewModel.loadClothingStyles()
                }
            }
            .toolbar {
                if !isAuthenticated {
                    Button(action: {
                        signInWithApple() 
                    }) {
                        Text("Войти через Apple")
                    }
                } else {
                    Text("Вы вошли как: User")
                }
            }
        }
    }

    private func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        AppDelegate.shared?.isAuthenticated = $isAuthenticated 
        controller.delegate = AppDelegate.shared
        controller.presentationContextProvider = AppDelegate.shared
        controller.performRequests()
    }
}
