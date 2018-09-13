import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let loginViewController = LoginViewController()
    try router.register(collection: loginViewController)

    let mainPageViewController = MainPageViewController()
    try router.register(collection: mainPageViewController)

    let usersController = UsersController()
    try router.register(collection: usersController)
}
