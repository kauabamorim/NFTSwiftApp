import SwiftUI
import Combine


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var responseData: String?
    @State private var isRegisterPresented = false
    @State private var isLoginSuccessful = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Login") {
                login()
            }
            .buttonStyle(.bordered)
            .padding()
            
            NavigationLink(
                isActive: $isRegisterPresented,
                destination: {
                    RegisterView()
                },
                label: {
                    EmptyView()
                }
            )
            
            Button("Register") {
                isRegisterPresented = true
            }
            .buttonStyle(.bordered)
            .padding()
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .alert(isPresented: .constant(true)) {
                        Alert(
                            title: Text("Erro de Login"),
                            message: Text(errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            }
        }
        .padding()
        .background(
            NavigationLink(
                destination: HomeView(),
                isActive: $isLoginSuccessful,
                label: {
                    EmptyView()
                }
            )
        )
    }
    
    func login() {
        let registerURL = URL(string: "http://localhost:3002/login")!
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            print("Erro ao serializar dados JSON: \(error)")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Erro na solicitação: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Resposta inválida")
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    print("Resposta do servidor: \(String(data: data, encoding: .utf8) ?? "")")
                    DispatchQueue.main.async {
                        self.responseData = String(data: data, encoding: .utf8)
                        self.isLoginSuccessful = true // Ativa a navegação para HomeView
                    }
                }
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let errorMessage = json?["message"] as? String {
                            print("Código de status inválido: \(httpResponse.statusCode), Mensagem: \(errorMessage)")
                            
                            DispatchQueue.main.async {
                                self.errorMessage = errorMessage
                            }
                        } else {
                            print("Código de status inválido: \(httpResponse.statusCode)")
                        }
                    } catch {
                        print("Erro ao analisar JSON: \(error)")
                    }
                }
            }
        }
        
        task.resume()
    }
}
