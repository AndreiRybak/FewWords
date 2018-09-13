//
//  MainPageViewController.swift
//  App
//
//  Created by Andrei Rybak on 9/8/18.
//

import Foundation
import Vapor
import Crypto

class MainPageViewController: RouteCollection {

    func boot(router: Router) throws {
        let mainPageGroup = router.grouped("posts")

        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let protected = mainPageGroup.grouped(basicAuthMiddleware)

        protected.get(use: getHandler)
    }

    func getHandler(_ request: Request) throws -> Future<View> {
        return try request.view().render("main")
    }

}
