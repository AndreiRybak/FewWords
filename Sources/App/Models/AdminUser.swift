//
//  AdminUser.swift
//  App
//
//  Created by Andrei Rybak on 9/9/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Crypto

final class AdminUser: Migration {

    typealias Database = PostgreSQLDatabase

    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let password = try? BCrypt.hash("6240540q")
        guard let hashedPassword = password else {
            fatalError("Failed to create admin user")
        }
        let user = User(name: "AndreiRybak", email: "andreyrybak0895@gmail.com", password: hashedPassword)
        return user.save(on: conn).transform(to: ())
    }

    static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
        return .done(on: conn)
    }

}
