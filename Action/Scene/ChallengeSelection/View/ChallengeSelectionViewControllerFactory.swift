import Foundation

enum ChallengeSelectionViewControllerFactory {
    
    static func make(for challengeProgram: ChallengeProgram, challenges: [Challenge]) -> ChallengeSelectionViewController {
        let interactor = ChallengeSelectionInteractor()
        let presenter = ChallengeSelectionPresenter()
        let router = ChallengeSelectionRouter()
        let viewController = ChallengeSelectionViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challengeProgram: challengeProgram, challenges: challenges)
        presenter.setup(with: viewController)
        router.setup(with: viewController, challengeStatusTransitioningDelegate: interactor)
        
        return viewController
    }
}
