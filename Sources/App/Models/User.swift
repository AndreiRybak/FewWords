//
//  User.swift
//  App
//
//  Created by Andrei Rybak on 8/25/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

final class User: Codable {
    var id: UUID?
    var username: String
    var email: String
    var password: String

    init(name: String, email: String, password: String) {
        self.username = name
        self.email = email
        self.password = password
    }

    final class Public: Codable {
        var id: UUID?
        var username: String
        var email: String

        init(id: UUID?, name: String, email: String) {
            self.id = id
            self.username = name
            self.email = email
        }
    }
}

extension User: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
        }
    }
}

extension User {
    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: username, email: email)
    }
}

extension Future where T: User {
    func convertToPublic() -> Future<User.Public> {
        return self.map(to: User.Public.self, { user in
            return user.convertToPublic()
        })
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}

extension User: PostgreSQLUUIDModel {}
extension User: Content {}
extension User: Parameter {}
extension User.Public: PostgreSQLUUIDModel {}
extension User.Public: Content {}
