//
//  userViewModel.swift
//  ProjectSwiftFullStack
//
//  Created by Kauã Berman Amorim on 13/12/23.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var token: String?

    func setUserAndToken(_ user: User, _ token: String) {
        self.user = user
        self.token = token
    }
}
