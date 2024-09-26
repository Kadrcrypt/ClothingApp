import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @StateObject private var viewModel = ClothingViewModel()
    @Binding var isAuthenticated: Bool

    var body: some View {
        NavigationView {
            VStack {
                if isAuthenticated {
                    List(viewModel.filteredClothingStyles) { style in
                        ClothingStyleView(style: style, viewModel: viewModel)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .navigationTitle("Стиль одежды")
                    .onAppear {
                        Task {
                            await viewModel.loadClothingStyles()
                        }
                    }
                } else {
                    AuthenticationView(isAuthenticated: $isAuthenticated)
                        .padding(.top, 100) // Положение кнопки в центре
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6)) // Фон для всей вью
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
