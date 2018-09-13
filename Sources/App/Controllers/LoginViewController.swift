//
//  WebsiteController.swift
//  App
//
//  Created by Andrei Rybak on 8/31/18.
//

import Vapor
import Leaf
import Crypto

class LoginViewController: RouteCollection {

    func boot(router: Router) throws {
        let loginPageGroup = router.grouped("login")
        loginPageGroup.get(use: loginPageHandler)

        let loginApiGroup = router.grouped("api")

        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = loginApiGroup.grouped(basicAuthMiddleware)

        basicAuthGroup.post("login", use: loginHandler)
    }

    func loginPageHandler(_ request: Request) throws -> Future<View> {
        let context = LoginViewContext(title: "Login")
        return try request.view().render("login", context)
    }

    func loginHandler(_ request: Request) throws -> Future<Token> {
        let user = try request.requireAuthenticated(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: request)
    }
}

struct LoginViewContext: Encodable {
    var title: String
}
