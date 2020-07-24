import Foundation

protocol ChallengeProgramInfoInteractorDelegate: AnyObject {
    func setup(with presenter: ChallengeProgramInfoPresenterDelegate, router: ChallengeProgramInfoRouterDelegate?, challengeProgram: ChallengeProgram)
    func handle(request: ChallengeProgramInfoRequest)
}

final class ChallengeProgramInfoInteractor: ChallengeProgramInfoInteractorDelegate {
    
    // MARK: Private properties
    private var presenter: ChallengeProgramInfoPresenterDelegate?
    private var router: ChallengeProgramInfoRouterDelegate?
    private var challengeProgram: ChallengeProgram?
    
    // MARK: Internal methods
    func setup(with presenter: ChallengeProgramInfoPresenterDelegate, router: ChallengeProgramInfoRouterDelegate?, challengeProgram: ChallengeProgram) {
        self.presenter = presenter
        self.router = router
        self.challengeProgram = challengeProgram
    }

    func handle(request: ChallengeProgramInfoRequest) {
        switch request {
        case .initialize:
            handleInitialize()
        case .readMore:
            handleReadMore()
        }
    }
}

// MARK: - Requests -

extension ChallengeProgramInfoInteractor {
    
    func handleInitialize() {
        guard let challengeProgram = self.challengeProgram else { return }
        
        presenter?.present(response: .initialize(challengeProgram: challengeProgram))
    }
    
    func handleReadMore() {
        guard let challengeProgram = self.challengeProgram else { return }
        router?.routeToBrowser(for: challengeProgram)
    }
}
