import Foundation

enum ChallengeProgramInfoViewControllerFactory {
    
    static func make(for challengeProgram: ChallengeProgram) -> ChallengeProgramInfoViewController {
        let interactor = ChallengeProgramInfoInteractor()
        let presenter = ChallengeProgramInfoPresenter()
        let router = ChallengeProgramInfoRouter()
        let viewController = ChallengeProgramInfoViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challengeProgram: challengeProgram)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
