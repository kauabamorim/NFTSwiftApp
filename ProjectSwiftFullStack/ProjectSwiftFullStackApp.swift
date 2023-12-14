//
//  ProjectSwiftFullStackApp.swift
//  ProjectSwiftFullStack
//
//  Created by Kauã Berman Amorim on 30/11/23.
//

import SwiftUI

@main
struct ProjectSwiftFullStackApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
