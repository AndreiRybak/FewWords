//
//  UserTests.swift
//  App
//
//  Created by Andrei Rybak on 8/29/18.
//

@testable import App
import Vapor
import FluentPostgreSQL
import XCTest

final class UserTests: XCTestCase {

    let usersURI = "/api/users/"

    let expectedUserName = "Andrew"
    let expectedUserEmail = "andrew@gmail.com"
    let expectedUserPassword = "54321"

    var app: Application!
    var connection: PostgreSQLConnection!


    override func setUp() {
        try! Application.reset()
        app = try! Application.testable()
        connection = try! app.newConnection(to: .psql).wait()
    }

    override func tearDown() {
        connection.close()
    }

    func testUserCanBeSaved() throws {
        let user = User(name: expectedUserName, email: expectedUserEmail, password: expectedUserPassword)
        let receivedUser = try app.getResponse(to: usersURI, method: .POST, headers: ["Content-Type": "application/json"], data: user, decodeTo: User.self)

        XCTAssertEqual(receivedUser.username, expectedUserName)
        XCTAssertEqual(receivedUser.email, expectedUserEmail)
        XCTAssertEqual(receivedUser.password, expectedUserPassword)
        XCTAssertNotNil(receivedUser.id)

        let users = try app.getResponse(to: usersURI, decodeTo: [User].self)

        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.username, expectedUserName)
        XCTAssertEqual(users.first?.email, expectedUserEmail)
        XCTAssertEqual(users.first?.password, expectedUserPassword)
        XCTAssertEqual(users.first?.id, receivedUser.id)
    }

    func testUserCanBeDeleted() throws {
        let _ = try User.create(on: connection)
        let _ = try User.create(on: connection)
        let lastUser = try User.create(on: connection)

        let allUsers = try app.getResponse(to: usersURI, decodeTo: [User].self)

        XCTAssertEqual(allUsers.count, 3)

        let _ = try app.sendRequest(to: "\(usersURI)\(lastUser.id!)", method: .DELETE)

        let remainingUsers = try app.getResponse(to: usersURI, decodeTo: [User].self)
        XCTAssertEqual(remainingUsers.count, 2)
    }

    func testUserCanBeUpdated() throws {
        let user = User(name: expectedUserName, email: expectedUserEmail, password: expectedUserPassword)
        let receivedUser = try app.getResponse(to: usersURI, method: .POST, headers: ["Content-Type": "application/json"], data: user, decodeTo: User.self)

        XCTAssertEqual(receivedUser.username, expectedUserName)
        XCTAssertEqual(receivedUser.email, expectedUserEmail)
        XCTAssertEqual(receivedUser.password, expectedUserPassword)
        XCTAssertNotNil(receivedUser.id)

        let expectedUpdatedUserName = "Alex"
        let expectedUpdatedUserEmail = "alex@gmail.com"
        let expectedUpdatedUserPassword = "qwerty"

        let userForUpdate = User(name: expectedUpdatedUserName, email: expectedUpdatedUserEmail, password: expectedUpdatedUserPassword)

        let receivedUpdatedUser = try app.getResponse(to: "\(usersURI)\(receivedUser.id!)", method: .PUT, headers: ["Content-Type": "application/json"], data: userForUpdate, decodeTo: User.self)

        XCTAssertEqual(receivedUpdatedUser.username, expectedUpdatedUserName)
        XCTAssertEqual(receivedUpdatedUser.email, expectedUpdatedUserEmail)
        XCTAssertEqual(receivedUpdatedUser.password, expectedUpdatedUserPassword)
        XCTAssertNotNil(receivedUpdatedUser.id)
    }

    func testGettingASingleUserI() throws {
        let user = try User.create(name: expectedUserName, email: expectedUserEmail, password: expectedUserPassword, on: connection)
        let receivedUser = try app.getResponse(to: "\(usersURI)\(user.id!)", decodeTo: User.self)

        XCTAssertEqual(receivedUser.username, expectedUserName)
        XCTAssertEqual(receivedUser.email, expectedUserEmail)
        XCTAssertEqual(receivedUser.password, expectedUserPassword)
        XCTAssertEqual(receivedUser.id, user.id)
    }

    func testUsersCanBeRetrieved() throws {
        let user = try User.create(name: expectedUserName, email: expectedUserEmail, password: expectedUserPassword, on: connection)
        let _ = try User.create(on: connection)

        let users = try app.getResponse(to: usersURI, decodeTo: [User].self)

        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.username, expectedUserName)
        XCTAssertEqual(users.first?.email, expectedUserEmail)
        XCTAssertEqual(users.first?.password, expectedUserPassword)
        XCTAssertEqual(users.first?.id, user.id)
    }

}
