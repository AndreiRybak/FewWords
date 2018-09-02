import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let loginViewController = LoginViewController()
    try router.register(collection: loginViewController)

    let usersController = UsersController()
    try router.register(collection: usersController)
}
