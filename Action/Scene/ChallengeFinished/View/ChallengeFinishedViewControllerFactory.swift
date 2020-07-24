import Foundation

enum ChallengeFinishedViewControllerFactory {
    
    static func make(for challenge: Challenge, routingCoordinator: ChallengeSelectionRouterDelegate) -> ChallengeFinishedViewController {
        let interactor = ChallengeFinishedInteractor()
        let presenter = ChallengeFinishedPresenter()
        let router = ChallengeFinishedRouter()
        let viewController = ChallengeFinishedViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challenge: challenge)
        presenter.setup(with: viewController)
        router.setup(with: viewController, routingCoordinator: routingCoordinator)
        
        return viewController
    }
}
