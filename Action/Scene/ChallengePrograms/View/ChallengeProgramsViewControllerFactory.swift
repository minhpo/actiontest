import Foundation

enum ChallengeProgramsViewControllerFactory {
    
    static func make() -> ChallengeProgramsViewController {
        let interactor = ChallengeProgramsInteractor()
        let presenter = ChallengeProgramsPresenter()
        let router = ChallengeProgramsRouter()
        let viewController = ChallengeProgramsViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
