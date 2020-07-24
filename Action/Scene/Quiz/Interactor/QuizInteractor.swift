import Foundation

protocol QuizInteractorDelegate: AnyObject {
    func setup(with presenter: QuizPresenterDelegate, router: QuizRouterDelegate?, challengeProgram: ChallengeProgram)
    func handle(request: QuizRequest)
}

final class QuizInteractor: QuizInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: QuizPresenterDelegate?
    private var router: QuizRouterDelegate?
    private var challengeProgram: ChallengeProgram?
    
    // MARK: Internal methods
    func setup(with presenter: QuizPresenterDelegate, router: QuizRouterDelegate?, challengeProgram: ChallengeProgram) {
        self.presenter = presenter
        self.router = router
        self.challengeProgram = challengeProgram
    }

    func handle(request: QuizRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        }
    }
}

// MARK: - Requests
extension QuizInteractor {
    
    func handleInitialize() {
        
    }
}
