//
//  ContentView.swift
//  ProjectSwiftFullStack
//
//  Created by Kauã Berman Amorim on 30/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView { 
            LoginView()
                .navigationTitle("Login")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
