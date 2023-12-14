//
//  userModel.swift
//  ProjectSwiftFullStack
//
//  Created by Kauã Berman Amorim on 13/12/23.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let name: String
    let lastName: String
    let password: String
    let username: String
}
