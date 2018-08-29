//
//  Model+Testable.swift
//  App
//
//  Created by Andrei Rybak on 8/29/18.
//

@testable import App
import Vapor
import FluentPostgreSQL

extension User {
    static func create(name: String = "Andrei", email: String = "andrei@gmail.com", password: String = "12345", on connection: PostgreSQLConnection) throws -> User {
        let user = User(name: name, email: email, password: password)
        return try user.save(on: connection).wait()
    }
}
