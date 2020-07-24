import Foundation

enum ChallengeProgramViewControllerFactory {
    
    static func make(for challengeProgram: ChallengeProgram) -> ChallengeProgramViewController {
        let interactor = ChallengeProgramInteractor()
        let presenter = ChallengeProgramPresenter()
        let router = ChallengeProgramRouter()
        let viewController = ChallengeProgramViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challengeProgram: challengeProgram)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
