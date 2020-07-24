import Foundation

enum LoginViewControllerFactory {
    
    static func make() -> LoginViewController {
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        let viewController = LoginViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
