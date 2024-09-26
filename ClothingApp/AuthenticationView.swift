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
    
    @State private var phoneOrEmail: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                
                Text("Авторизация")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .shadow(radius: 1)
                    .padding([.leading, .trailing], 40)
                
                TextField("Телефон или эл. почта", text: $phoneOrEmail)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                    .padding([.leading, .trailing], 40)

                SecureField("Пароль", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                    .padding([.leading, .trailing, .top], 40)

                // Кнопка Войти
                Button(action: {
                    print("Вход по логину и паролю: \(phoneOrEmail), \(password)")
                    // Тут надо логику авторизации через тупой метод email/phone password
                }) {
                    Text("Войти")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding([.leading, .trailing, .top], 40)

                Text("Или")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                    .padding(.bottom, 10)

                Button(action: {
                    signInWithApple()
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text("Войти через Apple ID")
                            .font(.subheadline)
                            .padding(10)
                    }
                    .padding(5)
                    .frame(maxWidth: 250)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding([.leading, .trailing, .bottom], 40)

                Spacer()
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
            if isAuthenticated {
                ContentView(isAuthenticated: $isAuthenticated) // Перенаправление на ContentView после авторизации
            } else {
                AuthenticationView(isAuthenticated: $isAuthenticated) // Вход через Apple ID
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(isAuthenticated: .constant(false))
            .preferredColorScheme(.light)
            .previewDevice("iPhone 14")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isAuthenticated: .constant(true))
            .preferredColorScheme(.light)
            .previewDevice("iPhone 14")
    }
}
