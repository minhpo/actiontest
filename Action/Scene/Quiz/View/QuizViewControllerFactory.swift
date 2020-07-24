import Foundation

enum QuizViewControllerFactory {
    
    static func make(for challengeProgram: ChallengeProgram) -> QuizViewController {
        let interactor = QuizInteractor()
        let presenter = QuizPresenter()
        let router = QuizRouter()
        let viewController = QuizViewController(interactor: interactor)
        
        interactor.setup(with: presenter, router: router, challengeProgram: challengeProgram)
        presenter.setup(with: viewController)
        router.setup(with: viewController)
        
        return viewController
    }
}
