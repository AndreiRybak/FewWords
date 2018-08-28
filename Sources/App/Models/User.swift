//
//  User.swift
//  App
//
//  Created by Andrei Rybak on 8/25/18.
//

import Vapor
import FluentPostgreSQL

final class User: Codable {
    var id: UUID?
    var name: String
    var email: String
    var password: String

    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
