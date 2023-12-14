import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            TabView {
                CollectionsView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                Text("Outro conteúdo")
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Segunda Aba")
                    }
                
                Text("Mais conteúdo")
                    .tabItem {
                        Image(systemName: "3.circle")
                        Text("Terceira Aba")
                    }
                
                ConfigView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Configuração")
                    }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
