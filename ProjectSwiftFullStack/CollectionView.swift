import SwiftUI

import Foundation

struct AllUsersResponse: Codable {
    let allUsers: [User]
}

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let lastName: String
    let password: String
    let username: String
}


struct CollectionsView: View {
    @State private var searchText: String = ""
    @State private var userField: String = ""
    @State private var users: [User] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Collections")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "bell.fill")
                    .imageScale(.large)
                
                Image(systemName: "bag.fill")
                    .imageScale(.large)
                    .padding()
            }
            .background(Color(.systemBackground))
            
            TextField("Search", text: $searchText)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray)
                        .background(Color.gray.opacity(0.4).cornerRadius(20))
                )
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        Spacer()
                    }
                )
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
                .padding(.top, 5)
            
            HStack {
                Text("1w Trending")
                    .font(.system(size: 23))
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("NFT")
                    .font(.system(size: 23))
                    .fontWeight(.bold)
                
                Text("Authors")
                        .font(.system(size: 23))
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 15)
            
            List(users, id: \.id) { user in
                Text(user.username)
                    .font(.system(size: 14))
            }
            .onAppear {
                getAllUser()
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .navigationBarHidden(true)
    }
    
    func getAllUser() {
        guard let url = URL(string: "http://localhost:3002/allUsers") else {
            print("URL inválida")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro na solicitação: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Resposta inválida")
                return
            }
            
            if httpResponse.statusCode == 200, let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(AllUsersResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        users = response.allUsers
                    }
                    print(response.allUsers)
                } catch {
                    print("Erro ao decodificar JSON: \(error)")
                }
            } else {
                print("Código de status inválido: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
}
struct CollectionsView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionsView()
    }
}
