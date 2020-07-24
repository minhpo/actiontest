import Foundation

enum LaunchViewControllerFactory {
    
    static func make() -> LaunchViewController {
        let interactor = LaunchInteractor()
        let presenter = LaunchPresenter()
        let router = LaunchRouter()
        let viewController = LaunchViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
