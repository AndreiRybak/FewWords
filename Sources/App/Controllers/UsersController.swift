//
//  UserController.swift
//  App
//
//  Created by Andrei Rybak on 8/28/18.
//

import Vapor
import Crypto

class UsersController: RouteCollection {

    func boot(router: Router) throws {
        let usersGroup = router.grouped("api", "users")

        usersGroup.get(use: getAllHandler)
        usersGroup.post(User.self, use: createHandler)
        usersGroup.get(User.parameter, use: getHandler)
        usersGroup.put(User.parameter, use: updateHandler)
        usersGroup.delete(User.parameter, use: deleteHandler)
    }

    func getAllHandler(request: Request) throws -> Future<[User.Public]> {
        return User.query(on: request).decode(User.Public.self).all()
    }

    func createHandler(request: Request, user: User) throws -> Future<User.Public> {
        user.password = try BCrypt.hash(user.password)
        return user.save(on: request).convertToPublic()
    }

    func getHandler(request: Request) throws -> Future<User.Public> {
        return try request.parameters.next(User.self).convertToPublic()
    }

    func updateHandler(request: Request) throws -> Future<User.Public> {
        return try flatMap(to: User.Public.self, request.parameters.next(User.self), request.content.decode(User.self), { (user, updatedUser) in
            user.username = updatedUser.username
            user.email = updatedUser.email
            user.password = updatedUser.password
            return user.save(on: request).convertToPublic()
        })
    }

    func deleteHandler(request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(User.self).delete(on: request).transform(to: HTTPStatus.noContent)
    }

}
