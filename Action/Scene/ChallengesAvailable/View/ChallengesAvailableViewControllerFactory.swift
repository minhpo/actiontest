import Foundation

enum ChallengesAvailableViewControllerFactory {
    
    static func make(for challengeProgram: ChallengeProgram, challenges: [Challenge], routingCoordinator: ChallengeSelectionRouterDelegate) -> ChallengesAvailableViewController {
        let interactor = ChallengesAvailableInteractor()
        let presenter = ChallengesAvailablePresenter()
        let router = ChallengesAvailableRouter()
        let viewController = ChallengesAvailableViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challengeProgram: challengeProgram, challenges: challenges)
        presenter.setup(with: viewController)
        router.setup(with: viewController, routingCoordinator: routingCoordinator)
        
        return viewController
    }
}
