import Foundation

enum ChallengeViewControllerFactory {
    
    static func make(for challenge: Challenge, withTransitionDelegate delegate: ChallengeStatusTransitioningDelegate) -> ChallengeViewController {
        let interactor = ChallengeInteractor()
        let presenter = ChallengePresenter()
        let router = ChallengeRouter()
        let viewController = ChallengeViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challenge: challenge, challengeStatusTransitioningDelegate: delegate)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
