//
//  WebsiteController.swift
//  App
//
//  Created by Andrei Rybak on 8/31/18.
//

import Vapor
import Leaf

class LoginViewController: RouteCollection {

    func boot(router: Router) throws {
        router.get("login", use: loginHandler)
    }

    func loginHandler(_ request: Request) throws -> Future<View> {
        let context = LoginViewContext(title: "Login")
        return try request.view().render("login", context)
    }
}

struct LoginViewContext: Encodable {
    var title: String
}
