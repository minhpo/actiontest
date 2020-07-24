import Foundation

enum ChallengeActiveViewControllerFactory {
    
    static func make(for challenge: Challenge, routingCoordinator: ChallengeSelectionRouterDelegate) -> ChallengeActiveViewController {
        let interactor = ChallengeActiveInteractor()
        let presenter = ChallengeActivePresenter()
        let router = ChallengeActiveRouter()
        let viewController = ChallengeActiveViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challenge: challenge)
        presenter.setup(with: viewController)
        router.setup(with: viewController, routingCoordinator: routingCoordinator)
        
        return viewController
    }
}
