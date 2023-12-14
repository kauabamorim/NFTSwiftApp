import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var responseData: String?
    @State private var isRegisterSuccessful = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .padding()
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Register") {
                        register()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding()
                    .alert(isPresented: $isRegisterSuccessful) {
                        Alert(
                            title: Text("Registration Successful"),
                            message: Text("Your registration has been successfully completed."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .shadow(radius: 5)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
    
    func register() {
        let registerURL = URL(string: "http://localhost:3002/register")!
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "name": name,
            "lastName": lastName,
            "username": username
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
                        self.isRegisterSuccessful = true
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

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        SecureField(placeholder, text: $text)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.8) : Color.accentColor)
            .cornerRadius(8)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
