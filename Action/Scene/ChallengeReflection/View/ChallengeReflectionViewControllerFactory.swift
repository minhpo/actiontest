import Foundation

enum ChallengeReflectionViewControllerFactory {
    
    static func make(for challenge: Challenge, withTransitionDelegate transitionDelegate: ChallengeStatusTransitioningDelegate, withReflectionDelegate reflectionDelegate: ChallengeReflectionDelegate) -> ChallengeReflectionViewController {
        let interactor = ChallengeReflectionInteractor()
        let presenter = ChallengeReflectionPresenter()
        let router = ChallengeReflectionRouter()
        let viewController = ChallengeReflectionViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challenge: challenge, challengeStatusTransitioningDelegate: transitionDelegate, challengeReflectionDelegate: reflectionDelegate)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
