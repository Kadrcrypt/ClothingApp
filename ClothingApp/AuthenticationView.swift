import SwiftUI
import AuthenticationServices

class AppDelegate: NSObject, UIApplicationDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    static var shared: AppDelegate?

    var isAuthenticated: Binding<Bool>?

    override init() {
        super.init()
        AppDelegate.shared = self
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes.first {
            $0 is UIWindowScene
        } as? UIWindowScene
        return windowScene?.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("Успешный вход: \(appleIDCredential.user)")
            isAuthenticated?.wrappedValue = true
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Ошибка при входе: \(error.localizedDescription)")
    }
}

struct AuthenticationView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        Button(action: {
            signInWithApple()
        }) {
            Text("Войти через Apple ID")
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

// Main Content View
struct MainContentView: View {
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

@main
struct MyClothingAppApp: App {
    @State private var isAuthenticated = false

    init() {
        _ = AppDelegate()
    }

    var body: some Scene {
        WindowGroup {
            MainContentView(isAuthenticated: $isAuthenticated) 
        }
    }
}
